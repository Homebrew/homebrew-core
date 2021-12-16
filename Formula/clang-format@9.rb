class ClangFormatAT9 < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/llvm-9.0.1.src.tar.xz"
  sha256 "00a1ee1f389f81e9979f3a640a01c431b3021de0d42278f6508391a2f0b81c9a"
  license "Apache-2.0"

  depends_on "cmake" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "clang" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/clang-9.0.1.src.tar.xz"
    sha256 "5778512b2e065c204010f88777d44b95250671103e434f9dc7363ab2e3804253"
  end

  def install
    (buildpath/"tools/clang").install resource("clang")

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build", "--target", "clang-format"

    bin.install buildpath/"build/bin/clang-format" => "clang-format-9"
    bin.install buildpath/"tools/clang/tools/clang-format/git-clang-format" => "git-clang-format-9"
  end

  test do
    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format-9 -style=Google test.c")
  end
end
