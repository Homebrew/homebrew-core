class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.4/llvm-17.0.4.src.tar.xz"
    sha256 "4f5907fb547947d10df35230a0fc73cf2f81aa12e09fc8de96c023425412c9f6"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.4/clang-17.0.4.src.tar.xz"
      sha256 "56c99515be2f245848dacc60fe85fe9de66cdc438ea0a1b82640e68384d0e432"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.4/cmake-17.0.4.src.tar.xz"
      sha256 "1a5cbe4a1fcda56ecdd80f42c3437060a28c97ec31de1748f6ba6aa84948fb0f"
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.4/third-party-17.0.4.src.tar.xz"
      sha256 "49358a7da2f49149a3028bf3aa6389052d4ebc15c548699cf19694141fdea847"
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e167db06df732c75972432934e6c4c3d1d07804ee7e923b53757efceb0b7d43e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecb1159b1815293934884dea028fae88072e45feae2233bbf7634ee92430f843"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d5224379d3c6a2959b87b0416b3881a6903f3a4fe74043edf523ba7cda39b3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "79507a5f295e8af44d7ccf905b9987adaf10c8c851a70fac76056c3cc46dea7c"
    sha256 cellar: :any_skip_relocation, ventura:        "f7a3ff2f2e57bda4b497827765f1d00efc17132fe1a204617ee5acd93c764603"
    sha256 cellar: :any_skip_relocation, monterey:       "1997f0e20715b5ed14b9663f92d762fe7f520c75d213865be1ba863416cc30ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f22fb5b1c6b053d07de9fb65e57dd8453eb7b57c959d61288f8ebe0e723be8b"
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
