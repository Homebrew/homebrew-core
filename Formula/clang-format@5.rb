class ClangFormatAT5 < Formula
  desc "Formatting tool for C/C++/Java/JavaScript/Objective-C/Protobuf"
  homepage "https://releases.llvm.org/5.0.2/tools/clang/docs/ClangFormat.html"
  version "5.0.2"

  if MacOS.version >= :sierra
    url "https://llvm.org/svn/llvm-project/llvm/tags/RELEASE_502/final/", :using => :svn
  else
    url "http://llvm.org/svn/llvm-project/llvm/tags/RELEASE_502/final/", :using => :svn
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "subversion" => :build

  resource "clang" do
    if MacOS.version >= :sierra
      url "https://llvm.org/svn/llvm-project/cfe/tags/RELEASE_502/final/", :using => :svn
    else
      url "http://llvm.org/svn/llvm-project/cfe/tags/RELEASE_502/final/", :using => :svn
    end
  end

  resource "libcxx" do
    url "https://releases.llvm.org/5.0.0/libcxx-5.0.0.src.tar.xz"
    sha256 "eae5981e9a21ef0decfcac80a1af584ddb064a32805f95a57c7c83a5eb28c9b1"
  end

  def install
    (buildpath/"projects/libcxx").install resource("libcxx")
    (buildpath/"tools/clang").install resource("clang")

    mkdir "build" do
      args = std_cmake_args
      args << "-DCMAKE_OSX_SYSROOT=/" unless MacOS::Xcode.installed?
      args << "-DLLVM_ENABLE_LIBCXX=ON"
      args << ".."
      system "cmake", "-G", "Ninja", *args
      system "ninja", "clang-format"
      bin.install "bin/clang-format"
    end
    bin.install "tools/clang/tools/clang-format/git-clang-format"
    (share/"clang").install Dir["tools/clang/tools/clang-format/clang-format*"]
  end

  test do
    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")

    # below code is messily formatted on purpose.
    (testpath/"test2.h").write <<~EOS
      #import  "package/file.h"
      @interface SomePlugin   : NSObject  < ParentPlugin >
      @end
    EOS

    # NOTE! different formatting depending on version
    # clang-format 5.x
    #     @interface SomePlugin : NSObject<ParentPlugin>
    # clang-format 6.x, 7.x
    #     @interface SomePlugin : NSObject <ParentPlugin>
    assert_equal "#import \"package/file.h\"\n@interface SomePlugin : NSObject<ParentPlugin>\n@end\n",
        shell_output("#{bin}/clang-format -style=Google test2.h")
  end
end
