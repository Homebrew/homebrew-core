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

  # According to the official llvm readme, GCC 4.7+ is required
  fails_with :gcc_4_0
  fails_with :gcc
  ("4.3".."4.6").each do |n|
    fails_with :gcc => n
  end

  def install
    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    (buildpath/"tools/clang").install resource("clang")

    args = %w[
      -DLLVM_OPTIMIZED_TABLEGEN=ON
      -DLLVM_INCLUDE_DOCS=OFF
      -DLLVM_TARGETS_TO_BUILD=all
    ]
    args << "-DLIBOMP_ARCH=x86_64"

    mktemp do
      system "cmake", "-G", "Unix Makefiles", buildpath, *(std_cmake_args + args)
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

        // get top/last location of the file
        CXSourceLocation topLoc  = clang_getLocationForOffset(tu, file, 0);
        CXSourceLocation lastLoc = clang_getLocationForOffset(tu, file, fileSize);
        if (clang_equalLocations(topLoc,  clang_getNullLocation()) ||
            clang_equalLocations(lastLoc, clang_getNullLocation()) ) {
          printf("cannot retrieve location\\n");
          exit(1);
        }

        // make a range from locations
        CXSourceRange range = clang_getRange(topLoc, lastLoc);
        if (clang_Range_isNull(range)) {
          printf("cannot retrieve range\\n");
          exit(1);
        }

        return range;
      }

      int main(int argc, char **argv) {
        if (argc < 2) {
          printf("Tokenize filename [options ...]\\n");
          exit(1);
        }

        const auto filename = argv[1];
        const auto cmdArgs = &argv[2];
        auto numArgs = argc - 2;

        CXIndex index = clang_createIndex(1, 0);
        CXTranslationUnit tu = clang_parseTranslationUnit(index, filename, cmdArgs, numArgs, NULL, 0, 0);
        if (tu == NULL) {
          printf("Cannot parse translation unit\\n");
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

    sorted_testresult = testresult.split("\n").sort.join("\n")
    expected_result = <<~EOS
      NumTokens: 8
    EOS

    assert_equal expected_result.strip, sorted_testresult.strip
  end
end
