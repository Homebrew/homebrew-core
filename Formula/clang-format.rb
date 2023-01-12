class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.7/llvm-15.0.7.src.tar.xz"
    sha256 "4ad8b2cc8003c86d0078d15d987d84e3a739f24aae9033865c027abae93ee7a4"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.7/clang-15.0.7.src.tar.xz"
      sha256 "a6b673ef15377fb46062d164e8ddc4d05c348ff8968f015f7f4af03f51000067"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.7/cmake-15.0.7.src.tar.xz"
      sha256 "8986f29b634fdaa9862eedda78513969fe9788301c9f2d938f4c10a3e7a3e7ea"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/llvmorg[._-]v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbf56abfb24a21c165be6354c24784fda0404eb0009acb24e7764f985cc46396"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "863c6e225f28a486e59d9581a15a138f12a79be7ec0e88bfbb7a13dce69caed2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9dff09df90416010de10c0f2d5827d7088f752747b79c4b1dc2fdbfc8ec82bf2"
    sha256 cellar: :any_skip_relocation, ventura:        "eaa6987f545e773b2af7030555198e441ce18ff1fc0be8728757cb167e271a4b"
    sha256 cellar: :any_skip_relocation, monterey:       "f2057cfecd05af214a620f359634001fe78fb25b21ec2c19885cd57e38af9e6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "047d4e2321824b31d4ec0208a85e114e579255c210f62e0415f618f1fbbe3362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a0d2f67c64a65e9411420b052c6f3cc234879ff62c8306c3090c19298abb4cc"
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
