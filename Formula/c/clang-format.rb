class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.1/llvm-17.0.1.src.tar.xz"
    sha256 "6acbd59b0a5156b61e82157915ee962a56e13d97aa5fcaa959b68809290893d1"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.1/clang-17.0.1.src.tar.xz"
      sha256 "af5dd15ff53dd6b483e64cac2f0a15fbbb7b80a672ed768f7ca30c781978ef39"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.1/cmake-17.0.1.src.tar.xz"
      sha256 "46e745d9bdcd2e18719a47b080e65fd476e1f6c4bbaa5947e4dee057458b78bc"
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.1/third-party-17.0.1.src.tar.xz"
      sha256 "ea7cc0781c3dba556bf7596f8283e62561fee3648880e27e1af7e0db4d34d918"
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d68f5c8fbe644e11889d82ad010475ed66dd2e13a29ac7b1b46399bd68b1a56d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a89fc6033b331f04046258e64004c0bac2ead4f383348b97e5e87deecec5c29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d453796bb77e3cd31f8836d499289ab1cef6ed07bef193eaf3ca924c42bdf18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86671d1a34300a72be994889e2ee44fe6850f2b802e253ee0b8712b5ec7f368b"
    sha256 cellar: :any_skip_relocation, sonoma:         "48aab6b1a3267b7f8315b30cfcaf489d63affeabf8fd6b643d85964ac55e032c"
    sha256 cellar: :any_skip_relocation, ventura:        "788c2638a518ee5c3c017c3360d732dc222955e6aaa7cf31ee162c8e9610d8a1"
    sha256 cellar: :any_skip_relocation, monterey:       "fa6015cf39648535b2c33f486b25e144bf6ff3ff689c2d99b9e32b24e8cc04c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bb72238533d316c3dc4963848ebfcfad07f201cd682425ee24d4d2cf712bd46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d17800e3c917c4596051d34745880c45c0dfcf81a6e2fc7440f8b95fb1967ef"
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
