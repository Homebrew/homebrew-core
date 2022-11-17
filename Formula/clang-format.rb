class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.4/llvm-15.0.4.src.tar.xz"
    sha256 "60aca410cae2b92665c0aa769bcd11ed17030b9ecd76115138c97d94a27a992f"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.4/clang-15.0.4.src.tar.xz"
      sha256 "701f8ff9b9727d12be456256e2811c5452259282c387728e2bcd95da90c5af45"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.4/cmake-15.0.4.src.tar.xz"
      sha256 "9df45bf3a0a46264d5007485592381bbaf50f034b4155290cb0d917539d8facf"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/llvmorg[._-]v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22ce42d45047a82dbaeb294c988491c8dc41a14db585aba895289b94c98567b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6687055a4bbb8c45c534c97593da173020a89464131f8e28d9c51635abdf85e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "635e65e903d7509bc7b66246b33e80c2c6fa7970ae5ae976b8115346298684af"
    sha256 cellar: :any_skip_relocation, ventura:        "313506ad3a59bdea702b964c76784cb280041960faff6f4ef30327a28e79107b"
    sha256 cellar: :any_skip_relocation, monterey:       "840020306f475284733e073f7d3d1f4c2f2e14b8e1a89d79bfa2df8d4dee2c53"
    sha256 cellar: :any_skip_relocation, big_sur:        "9743f1cb8befbaacba5b60e22762fab2db9337fcbddb66ee9fae69ccb54174ab"
    sha256 cellar: :any_skip_relocation, catalina:       "44458ac88b30b5fddfa0a9679339a6fdca3ad0cd9591f655387d7d12f85ce383"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba30cee4820b592e8ff594fe0174246286ed062c709e058c713d882a073ac388"
  end

  depends_on "cmake" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "python", since: :catalina
  uses_from_macos "zlib"

  on_linux do
    keg_only "it conflicts with llvm"
  end

  def install
    llvmpath = if build.head?
      ln_s buildpath/"clang", buildpath/"llvm/tools/clang"

      buildpath/"llvm"
    else
      (buildpath/"src").install buildpath.children
      (buildpath/"src/tools/clang").install resource("clang")
      (buildpath/"cmake").install resource("cmake")

      buildpath/"src"
    end

    system "cmake", "-S", llvmpath, "-B", "build",
                    "-DLLVM_EXTERNAL_PROJECTS=clang",
                    "-DLLVM_INCLUDE_BENCHMARKS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build", "--target", "clang-format"

    bin.install "build/bin/clang-format"
    bin.install llvmpath/"tools/clang/tools/clang-format/git-clang-format"
    (share/"clang").install llvmpath.glob("tools/clang/tools/clang-format/clang-format*")
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "initial commit", "--quiet"

    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS
    system "git", "add", "test.c"

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")

    ENV.prepend_path "PATH", bin
    assert_match "test.c", shell_output("git clang-format", 1)
  end
end
