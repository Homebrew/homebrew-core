class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.1/llvm-11.0.1.src.tar.xz"
    sha256 "ccd87c254b6aebc5077e4e6977d08d4be888e7eb672c6630a26a15d58b59b528"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-11.0.1/clang-11.0.1.src.tar.xz"
      sha256 "73f572c2eefc5a155e01bcd84815751d722a4d3925f53c144acfb93eeb274b4d"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/llvmorg[._-]v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bc823d2b0fe175abfecaf85f913035a4a27cec9054a2f094608f295f1a040069"
    sha256 cellar: :any_skip_relocation, big_sur:       "a2a124fe20d721ad490731dad173da4c7a57d635792739680a45c40cecd48409"
    sha256 cellar: :any_skip_relocation, catalina:      "c2a08aaf48ea39e832f9460c42c75b87f1296dc5c9360888a9eb297e3fd1ce28"
    sha256 cellar: :any_skip_relocation, mojave:        "37a27e538177b4d9b44eeb6d7749301eba4422763994189cc50f1e2c6cc21344"
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
