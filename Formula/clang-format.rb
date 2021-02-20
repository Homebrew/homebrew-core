class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.1.0/llvm-11.1.0.src.tar.xz"
    sha256 "ce8508e318a01a63d4e8b3090ab2ded3c598a50258cc49e2625b9120d4c03ea5"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.1.0/clang-11.1.0.src.tar.xz"
      sha256 "0a8288f065d1f57cb6d96da4d2965cbea32edc572aa972e466e954d17148558b"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/llvmorg[._-]v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "75d8d02db3431c770474fb5249e4ab051f0127084192a73e130d57a12b71c71b"
    sha256 cellar: :any_skip_relocation, big_sur:       "9a8d102c310fa5f6eb4be1680ba85a69c0ebd9c14790df346ba9ed2656d63a2f"
    sha256 cellar: :any_skip_relocation, catalina:      "3b0bf3e57d6347cc38913ab55be827c54d236cce927af06ef2cf55811a9926db"
    sha256 cellar: :any_skip_relocation, mojave:        "c5a0b53844fd9dd4b29e2de30e41c6d92bc39638003ca565af1d057253a6d634"
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
