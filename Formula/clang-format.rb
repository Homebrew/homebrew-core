class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.0/llvm-12.0.0.src.tar.xz"
    sha256 "49dc47c8697a1a0abd4ee51629a696d7bfe803662f2a7252a3b16fc75f3a8b50"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-12.0.0/clang-12.0.0.src.tar.xz"
      sha256 "e26e452e91d4542da3ebbf404f024d3e1cbf103f4cd110c26bf0a19621cca9ed"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/llvmorg[._-]v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1f038a1af0ed7c0c316cca7a5b74c868eb011ea5c1106bd34d451c7d99b16ca4"
    sha256 cellar: :any_skip_relocation, big_sur:       "a919653359246062c53f2ce6a7a3fd822e71b1d65c4f75bd20a361bc7264b139"
    sha256 cellar: :any_skip_relocation, catalina:      "e18818a9555c17fffdf416deb5e16526f4b7fb07ec684d5dda22b6b8b1fd7c4e"
    sha256 cellar: :any_skip_relocation, mojave:        "2ce598eddb5655854cc4a0e88591ced06b0a2d5bab96497c0b7081f5a2b0dd74"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
