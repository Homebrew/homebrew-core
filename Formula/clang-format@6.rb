class ClangFormatAT6 < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  url "https://releases.llvm.org/6.0.0/llvm-6.0.0.src.tar.xz"
  sha256 "1ff53c915b4e761ef400b803f07261ade637b0c269d99569f18040f3dcee4408"

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "subversion" => :build

  resource "clang" do
    url "https://releases.llvm.org/6.0.0/cfe-6.0.0.src.tar.xz"
    sha256 "e07d6dd8d9ef196cfc8e8bb131cbd6a2ed0b1caf1715f9d05b0f0eeaddb6df32"
  end

  resource "libcxx" do
    url "https://releases.llvm.org/6.0.0/libcxx-6.0.0.src.tar.xz"
    sha256 "70931a87bde9d358af6cb7869e7535ec6b015f7e6df64def6d2ecdd954040dd9"
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
    # the below C code is intentionally messily formatted.
    (testpath/"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")
  end
end
