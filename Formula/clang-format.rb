class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.0/llvm-13.0.0.src.tar.xz"
    sha256 "408d11708643ea826f519ff79761fcdfc12d641a2510229eec459e72f8163020"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.0/clang-13.0.0.src.tar.xz"
      sha256 "5d611cbb06cfb6626be46eb2f23d003b2b80f40182898daa54b1c4e8b5b9e17e"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/llvmorg[._-]v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4f6a5ed840cccc724fa7018634a10cb793c303772076ffd6f001f445235df63c"
    sha256 cellar: :any_skip_relocation, big_sur:       "2ecea9cf5259a440a55eb7493c9a2e2c831d94c1aa0f01ef93707415129a2e08"
    sha256 cellar: :any_skip_relocation, catalina:      "300fad934c6c2bbb348a1293e2d56813b40547c8e6bec9b50236dba15e3c5f1e"
    sha256 cellar: :any_skip_relocation, mojave:        "e532d4fe08eb491426eb1bb290f8c6275088ac6cee9b2d97e74ae77a95f7a9c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "389471e5cf1b8ed375389e7e9858cec22464a2c22227b232daea0980ce322df1"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
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
