/**
   Type translations
 */
module include.translation.type;

import include.from;

string translate(in from!"clang".Type type,
                 in from!"include.runtime.options".Options options =
                              from!"include.runtime.options".Options())
    @safe pure
{
    import clang: Type;
    import std.conv: text;
    import std.exception: enforce;

    switch(type.kind) with(Type.Kind) {

        default:
            throw new Exception(text("Type kind ", type.kind, " not supported: ", type));
            assert(0);

        case Long:
            version(Windows)
                return "int";
            else
                return "long";

        case ULong:
            version(Windows)
                return "uint";
            else
                return "ulong";

        case Pointer: return translatePointer(type).cleanType;
        case Typedef: return translateTypedef(type).cleanType;
        case Void: return "void";
        case NullPtr: return "void*";
        case Bool: return "bool";
        case WChar: return "wchar";
        case SChar: return "byte";
        case Char16: return "wchar";
        case Char32: return "dchar";
        case UChar: return "ubyte";
        case UShort: return "ushort";
        case Short: return "short";
        case Int: return "int";
        case UInt: return "uint";
        case LongLong: return "long";
        case ULongLong: return "ulong";
        case Float: return "float";
        case Double: return "double";
        case Elaborated: return type.spelling.cleanType;
        case ConstantArray: return type.spelling.cleanType;
    }
}

// FIXME: horrible hack for now
string translatePointer(in from!"clang".Type type) @safe pure {
    import clang: Type;
    assert(type.kind == Type.Kind.Pointer);

    switch(type.spelling) {

        default:
            return type.spelling;

        case "const char *":
            return "const(char)*";

        case "const int *":
            return "const(int)*";
    }
}

string cleanType(in string type) @safe pure {
    import std.array: replace;
    return type.replace("struct ", "");
}

// FIXME: horrible hack for now
string translateTypedef(in from!"clang".Type type) @safe pure {
    import clang: Type;
    assert(type.kind == Type.Kind.Typedef);

    switch(type.spelling) {
        default:
            return type.spelling;
        case "uint64_t":
            return "ulong";
    }
}
