class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.7/llvm-20.1.7.src.tar.xz"
    sha256 "10b62d003f16afbd1a5ee0aa6397704c13d9a12a2562103998a8c1eff4a0f1ea"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.7/clang-20.1.7.src.tar.xz"
      sha256 "cb74965a2481008ae405419357a55fda2df6fa3aee262a0a9293a558532a29ae"

      livecheck do
        formula :parent
      end
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.7/cmake-20.1.7.src.tar.xz"
      sha256 "afdab526c9b337a4eacbb401685beb98a18fb576037ecfaa93171d4c644fe791"

      livecheck do
        formula :parent
      end
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.7/third-party-20.1.7.src.tar.xz"
      sha256 "592019ad4d17ffa6e0162c7584474b2ae8883a61bbfade5f15382ed26b7ce52a"

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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11fa116d47569910a387014d5abf3f6a269fc156ff249e0933a934615e60d254"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5caf4489db4599930853d278732e9db7523247fa3a4d4a76cc6fe0b7a77d230e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "02601dee6406caafe7dafa53f5a9f32bc88d3f42d79598516268c5dffee1a08d"
    sha256 cellar: :any_skip_relocation, sonoma:        "49bb9c17d9638579bff556cc7924ab1c5ddd01f64b20a62f4b70b5aa18d2fe1a"
    sha256 cellar: :any_skip_relocation, ventura:       "50a22922df63cfc47e6de0330f240fb0757d254b0c59c53aa6e42cb2c6d93c10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fd0d9ca9edbf32d3770312a49d0c94097a25b30cc1b3b0c01f85fa4c4459491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e877aed438bc5c1b667e6f392479da6fd5f0a11636e9d2d2d213107b61b07531"
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
