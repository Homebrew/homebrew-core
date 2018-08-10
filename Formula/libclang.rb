class Libclang < Formula
  desc "C interface to clang"
  homepage "https://clang.llvm.org/doxygen/group__CINDEX.html"
  url "https://releases.llvm.org/6.0.1/llvm-6.0.1.src.tar.xz"
  sha256 "b6d6c324f9c71494c0ccaf3dac1f16236d970002b42bb24a6c9e1634f7d0f4e2"

  keg_only :provided_by_macos

  depends_on "cmake" => :build

  resource "clang" do
    url "https://releases.llvm.org/6.0.1/cfe-6.0.1.src.tar.xz"
    sha256 "7c243f1485bddfdfedada3cd402ff4792ea82362ff91fbdac2dae67c6026b667"
  end

  def install
    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    (buildpath/"tools/clang").install resource("clang")

    mktemp do
      system "cmake", "-G",
                      "Unix Makefiles",
                      buildpath,
                      *std_cmake_args,
                      "-DLLVM_OPTIMIZED_TABLEGEN=ON",
                      "-DLLVM_INCLUDE_DOCS=OFF",
                      "-DLLVM_TARGETS_TO_BUILD=all",
                      "-DLIBOMP_ARCH=x86_64"
      system "make", "libclang"
      system "make", "install"
    end

    (share/"clang/tools").install Dir["tools/clang/tools/scan-{build,view}"]
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/llvm-config --prefix").chomp

    (testpath/"sample.cpp").write <<~EOS
      int main("aa", /* "bb"= */1 )
    EOS

    (testpath/"libclangtest.cpp").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <clang-c/Index.h>

      const char *_getTokenKindSpelling(CXTokenKind kind) {
        switch (kind) {
          case CXToken_Punctuation: return "Punctuation"; break;
          case CXToken_Keyword:     return "Keyword"; break;
          case CXToken_Identifier:  return "Identifier"; break;
          case CXToken_Literal:     return "Literal"; break;
          case CXToken_Comment:     return "Comment"; break;
          default:                  return "Unknown"; break;
        }
      }

      unsigned get_filesize(const char *fileName) {
        FILE *fp = fopen(fileName, "r");
        fseek(fp, 0, SEEK_END);
        auto size = ftell(fp);
        fclose(fp);
        return size;
      }

      CXSourceRange get_filerange(const CXTranslationUnit &tu, const char *filename) {
        CXFile file = clang_getFile(tu, filename);
        auto fileSize = get_filesize(filename);

        CXSourceLocation topLoc  = clang_getLocationForOffset(tu, file, 0);
        CXSourceLocation lastLoc = clang_getLocationForOffset(tu, file, fileSize);
        if (clang_equalLocations(topLoc,  clang_getNullLocation()) ||
            clang_equalLocations(lastLoc, clang_getNullLocation()) ) {
          exit(1);
        }

        CXSourceRange range = clang_getRange(topLoc, lastLoc);
        if (clang_Range_isNull(range)) {
          exit(1);
        }

        return range;
      }

      int main(int argc, char **argv) {
        const auto filename = argv[1];
        CXIndex index = clang_createIndex(1, 0);
        CXTranslationUnit tu = clang_parseTranslationUnit(index, filename, NULL, 0, NULL, 0, 0);
        if (tu == NULL) {
          return 1;
        }

        CXSourceRange range = get_filerange(tu, filename);
        CXToken *tokens;
        unsigned numTokens;
        clang_tokenize(tu, range, &tokens, &numTokens);
        printf("NumTokens: %d\\n", numTokens);

        clang_disposeTokens(tu, tokens, numTokens);
        clang_disposeTranslationUnit(tu);
        clang_disposeIndex(index);
        return 0;
      }
    EOS

    system "#{bin}/clang", "-L#{lib}",
                           "-I#{include}", "-lclang",
                           "libclangtest.cpp", "-o", "libclangtest"
    testresult = shell_output("./libclangtest sample.cpp")

    expected_result = <<~EOS
      NumTokens: 8
    EOS

    assert_equal expected_result.strip, testresult.strip
  end
end
