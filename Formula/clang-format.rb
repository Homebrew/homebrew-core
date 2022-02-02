class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.1/llvm-13.0.1.src.tar.xz"
    sha256 "ec6b80d82c384acad2dc192903a6cf2cdbaffb889b84bfb98da9d71e630fc834"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.1/clang-13.0.1.src.tar.xz"
      sha256 "787a9e2d99f5c8720aa1773e4be009461cd30d3bd40fdd24591e473467c917c9"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/llvmorg[._-]v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b7e4600348068a6992ffdcf1dd5b15805b06602f0fbcd3618e0a5f9485dfe62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "024d9bfd4e595d4570f3d4f69079de27d30b3be451ddb838706bc3b1031a1a82"
    sha256 cellar: :any_skip_relocation, monterey:       "9266402a97d01407dfd553af9ab209d7d11ed07ab4179ec9d388548405088a4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "603d31d8ccff511e6c5e90e7fd4bc78c292f8f4cfc9a0d45034818ab8d855e0f"
    sha256 cellar: :any_skip_relocation, catalina:       "2a4ddc3215e486474d7a06450aff058396799b8bf4440b3e1c31453651df7e7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91e643eb54d035de3ad87987d060a6830ede1b16b8bb63c61af60670d84c1c44"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "python", since: :catalina
  uses_from_macos "zlib"

  on_linux do
    keg_only "it conflicts with llvm"
  end

  def install
    if build.head?
      ln_s buildpath/"clang", buildpath/"llvm/tools/clang"
    else
      (buildpath/"tools/clang").install resource("clang")
    end

    llvmpath = build.head? ? buildpath/"llvm" : buildpath

    mkdir llvmpath/"build" do
      args = std_cmake_args
      args << "-DLLVM_EXTERNAL_PROJECTS=\"clang\""
      args << ".."
      system "cmake", "-G", "Ninja", *args
      system "ninja", "clang-format"
    end

    bin.install llvmpath/"build/bin/clang-format"
    bin.install llvmpath/"tools/clang/tools/clang-format/git-clang-format"
    (share/"clang").install Dir[llvmpath/"tools/clang/tools/clang-format/clang-format*"]
  end

  test do
    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")
  end
end
