class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.6/llvm-16.0.6.src.tar.xz"
    sha256 "e91db44d1b3bb1c33fcea9a7d1f2423b883eaa9163d3d56ca2aa6d2f0711bc29"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.6/clang-16.0.6.src.tar.xz"
      sha256 "1186b6e6eefeadd09912ed73b3729e85b59f043724bb2818a95a2ec024571840"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.6/cmake-16.0.6.src.tar.xz"
      sha256 "39d342a4161095d2f28fb1253e4585978ac50521117da666e2b1f6f28b62f514"
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.6/third-party-16.0.6.src.tar.xz"
      sha256 "15f5b9aeeba938530af977d5f9205612737a091a7f0f6c8075df8723b7713f70"
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91f8990b07097ce1b70a7d0cf4141236f25ba541423be618a839330f380ce3ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0c6726be631b03ee7d48d4086df4b420d1fb5a62411ed08bee5a86e4916c0bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09ec7353241206bd516a26e869d8621edb0882279fcafe2cfc660f583646f15a"
    sha256 cellar: :any_skip_relocation, ventura:        "c6ecd35aa7796cb0beb3c3ad1bb83d7e6f649f679927e4d7ed9cff0bd4245ecf"
    sha256 cellar: :any_skip_relocation, monterey:       "2fe5c76681423b7125ef9db21d3ad1a37c47dda84909c6b4f9ac796a574ac450"
    sha256 cellar: :any_skip_relocation, big_sur:        "83cb029c9aa6f04c665d20040f5922a26f8fb06cadffce6115cba56da002f87f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cc843ad43e6d5e32e9935c21a6ef79d6878bdd74472695327296ffdc98380e3"
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
      (buildpath/"third-party").install resource("third-party")

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
