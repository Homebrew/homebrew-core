class ClangFormatAT5 < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  url "https://releases.llvm.org/5.0.2/llvm-5.0.2.src.tar.xz"
  sha256 "d522eda97835a9c75f0b88ddc81437e5edbb87dc2740686cb8647763855c2b3c"
  license "Apache-2.0"
  revision 1

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "clang" do
    url "https://releases.llvm.org/5.0.2/cfe-5.0.2.src.tar.xz"
    sha256 "fa9ce9724abdb68f166deea0af1f71ca0dfa9af8f7e1261f2cae63c280282800"
  end

  def install
    (buildpath/"tools/clang").install resource("clang")

    mkdir buildpath/"build" do
      args = std_cmake_args
      args << ".."
      system "cmake", "-G", "Ninja", *args
      system "ninja", "clang-format"
    end

    bin.install buildpath/"build/bin/clang-format" => "clang-format-5"
    bin.install buildpath/"tools/clang/tools/clang-format/git-clang-format" => "git-clang-format-5"
  end

  test do
    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format-5 -style=Google test.c")
  end
end
