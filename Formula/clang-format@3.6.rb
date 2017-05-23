class ClangFormatAT36 < Formula
  desc "Formatting tools for C/C++/ObjC/Java/JavaScript/TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  url "http://llvm.org/releases/3.6.0/llvm-3.6.0.src.tar.xz"
  sha256 "b39a69e501b49e8f73ff75c9ad72313681ee58d6f430bfad4d81846fe92eb9ce"

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "subversion" => :build

  resource "clang" do
    url "http://llvm.org/releases/3.6.0/cfe-3.6.0.src.tar.xz"
    sha256 "be0e69378119fe26f0f2f74cffe82b7c26da840c9733fe522ed3c1b66b11082d"
  end

  resource "libcxx" do
    url "http://llvm.org/releases/3.6.0/libcxx-3.6.0.src.tar.xz"
    sha256 "299c1e82b0086a79c5c1aa1885ea3be3bbce6979aaa9b886409b14f9b387fbb7"
  end

  def install
    (buildpath/"projects/libcxx").install resource("libcxx")
    (buildpath/"tools/clang").install resource("clang")

    mkdir "build" do
      args = std_cmake_args
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
    (testpath/"test.c").write <<-EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")
  end
end
