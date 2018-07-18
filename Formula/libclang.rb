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

    (testpath/"libclangtest.cpp").write <<~EOS
      #include "clang-c/Index.h"
      #include <stdio.h>

      int main(int argc, char** argv)
        {
          CXIndex idx = clang_createIndex(1, 0);
          const char *clangargs[] =
          {
            "-I.",
            "-x", "c++"
          };

          CXTranslationUnit tu = clang_parseTranslationUnit(idx,
             "libclangtest.cpp",
              clangargs, sizeof(clangargs)/sizeof(char*),
              NULL, 0,
              CXTranslationUnit_PrecompiledPreamble);

          if (!tu)
          {
            printf("Couldn't parse tu\\n");
            clang_disposeIndex(idx);
            return 1;
          }

          CXCodeCompleteResults* results = clang_codeCompleteAt(tu, "libclangtest.cpp", 10, 1, NULL, 0, clang_defaultCodeCompleteOptions());
          if (results)
          {
            clang_sortCodeCompletionResults(results->Results, results->NumResults);
            for (int i = 0; i < results->NumResults; i++)
            {
              CXCompletionString &compString = results->Results[i].CompletionString;
              for (int j = 0; j < clang_getNumCompletionChunks(compString); j++)
                {
                  CXString s = clang_getCompletionChunkText(compString, j);
                  //printf("%s ", clang_getCString(s));
                  clang_disposeString(s);
                }
                //printf("\\n");
            }
            clang_disposeCodeCompleteResults(results);
          }
          else
            {
              printf("Failed to perform completion operation\\n");
            }

          for (unsigned int i = 0; i < clang_getNumDiagnostics(tu); i++)
          {
            CXDiagnostic diag = clang_getDiagnostic(tu, i);
            CXString s = clang_getDiagnosticSpelling(diag);
            //printf("%s\\n", clang_getCString(s));
            clang_disposeString(s);
            clang_disposeDiagnostic(diag);
          }
          printf("Total diagnostics available: %d\\n", clang_getNumDiagnostics(tu));
          clang_disposeTranslationUnit(tu);
          clang_disposeIndex(idx);

          return 0;
        }
    EOS

    system "#{bin}/clang", "-L#{lib}",
                           "-I#{include}", "-lclang",
                           "libclangtest.cpp", "-o", "libclangtest"
    testresult = shell_output("./libclangtest")

    sorted_testresult = testresult.split("\n").sort.join("\n")
    expected_result = <<~EOS
      Total diagnostics available: 1
    EOS

    assert_equal expected_result.strip, sorted_testresult.strip
  end
end
