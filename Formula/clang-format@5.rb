class ClangFormatAT5 < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"

  stable do
    url "https://releases.llvm.org/5.0.2/llvm-5.0.2.src.tar.xz"
    sha256 "d522eda97835a9c75f0b88ddc81437e5edbb87dc2740686cb8647763855c2b3c"

    resource "clang" do
      url "https://releases.llvm.org/5.0.2/cfe-5.0.2.src.tar.xz"
      sha256 "fa9ce9724abdb68f166deea0af1f71ca0dfa9af8f7e1261f2cae63c280282800"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a8a1eb007f7828790a1605d2647e6848e1f9617c26c8d31bfcf56a075a20bafb" => :high_sierra
    sha256 "b4db7e4f2623195adaa475b0d5567de7fe3c1bb70449b35888aea69136c66931" => :sierra
    sha256 "30767fb6f85073ac7fc58a2d80135c52623d76c9f594087b489164e0df6f901c" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  resource "libcxx" do
    url "https://releases.llvm.org/5.0.2/libcxx-5.0.2.src.tar.xz"
    sha256 "6edf88e913175536e1182058753fff2365e388e017a9ec7427feb9929c52e298"
  end

  def install
    (buildpath/"projects/libcxx").install resource("libcxx")
    (buildpath/"tools/clang").install resource("clang")

    mkdir "build" do
      args = std_cmake_args
      args << "-DCMAKE_OSX_SYSROOT=/" unless MacOS::Xcode.installed?
      args << "-DLLVM_ENABLE_LIBCXX=ON"
      args << "-DCMAKE_BUILD_TYPE=Release"
      args << ".."
      system "cmake", "-G", "Ninja", *args
      system "ninja", "clang-format"
      add_suffix "bin/clang-format", 5.0
      bin.install "bin/clang-format-5.0"
    end
    add_suffix "tools/clang/tools/clang-format/git-clang-format", 5.0
    bin.install "tools/clang/tools/clang-format/git-clang-format-5.0"
  end

  def add_suffix(file, suffix)
    dir = File.dirname(file)
    ext = File.extname(file)
    base = File.basename(file, ext)
    File.rename file, "#{dir}/#{base}-#{suffix}#{ext}"
  end

  test do
    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format-5.0 -style=Google test.c")
  end
end
