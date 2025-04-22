class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.3/llvm-20.1.3.src.tar.xz"
    sha256 "e5dc9b9d842c5f79080f67860a084077e163430de1e2cd3a74e8bee86e186751"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.3/clang-20.1.3.src.tar.xz"
      sha256 "3cddfd12c81a64d2e6036478417e0314278aec3a76e1d197c6fa444a07ed6bfc"

      livecheck do
        formula :parent
      end
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.3/cmake-20.1.3.src.tar.xz"
      sha256 "d5423ec180f14df6041058a2b66e321e4420499e111235577e09515a38a03451"

      livecheck do
        formula :parent
      end
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.3/third-party-20.1.3.src.tar.xz"
      sha256 "bae96bfc535f4e8e27db8c7bce88d1236ae2af25afb70333b90aabf55168c186"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fda665f5fdf956de2b88ba791678e913750e706cfa7485c69a44f1f78b2b7647"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c09a609f09f556aca111155d15cb85ad63ae65b80c9696c478174524692caed9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dbf4e1a5b6e0ebaf2a15ec1d83191152b37f4fc8ffaeefa5172524b5cb28f742"
    sha256 cellar: :any_skip_relocation, sonoma:        "99c1f944187a41166538bc640cbc9e70e7403ea84cc0fdf5cfc5637c61895b18"
    sha256 cellar: :any_skip_relocation, ventura:       "af0b67fa6690871f496fd1fe61784c05eaa4d796b93edad3718f650b160e8e94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21a6a4f7fae2ae144cdb89e3d75830c4c0fa50b5ab1e0a47521edfcf2bfc9773"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab8fe204cba2f2713835591ab90aa93f8ed34de66d21bfddf20f256c7d388abc"
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
    odie "clang resource needs to be updated" if build.stable? && version != resource("clang").version
    odie "cmake resource needs to be updated" if build.stable? && version != resource("cmake").version
    odie "third-party resource needs to be updated" if build.stable? && version != resource("third-party").version

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
    (testpath/"test.c").write <<~C
      int         main(char *args) { \n   \t printf("hello"); }
    C
    system "git", "add", "test.c"

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")

    ENV.prepend_path "PATH", bin
    assert_match "test.c", shell_output("git clang-format", 1)
  end
end
