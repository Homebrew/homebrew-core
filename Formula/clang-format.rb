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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3c53fc8d8d635d33e1c95c93d3145c8634f892c39d68057d6301ff2bc134cac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6e1a6486b61841a48d09be26afcd1d63618e47201070f363835db32f3c2a35f"
    sha256 cellar: :any_skip_relocation, monterey:       "3ba5e6a954227679fb2b958d6f102a01e3ba06b255c67468bb5813cf14f135a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c9cf9dcf1d657527109a72a84245c576e46660be33672e8af2aab796a6259be"
    sha256 cellar: :any_skip_relocation, catalina:       "7b894aa194d712708e0eb04ac4445098bf941d748fc1a7920763d1927c5a72a3"
    sha256 cellar: :any_skip_relocation, mojave:         "ff867f295ac041dfafcee2ae960ef373d68295c11d1c9e911b5b4ac1828eb444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f15d3cfcebe8159631ddfa84dec5d6389bfaf1220c2a26692bbc6cb4e7fa8b7e"
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
