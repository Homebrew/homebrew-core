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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41d0d91e2e907ace66e1953d5a168184df17d037790fed85c88343d2edeead0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dcd7e5ff0409d334bd0c73b04d78c06bea4c2e96947a020b0b45e9cf6be6cb91"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ecb153d38f5c6289bc29f9e95e95083a6bb8cbb2de267cf6a4ba0a704879e5c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c70f9b002a25204557219c1c5bfb3ab9413eb144b26743d21706ecc2887cffa2"
    sha256 cellar: :any_skip_relocation, ventura:       "51bc37d111493cd3f4c7e7bc4809cf49273e274b4139129e3a0ba2c2d532fe68"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e39bb2ec020dbeac089b42e66863187764ae9626c87de068b3f49315763f735"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03b69ef3ee95a779cefd0af5919f8690ae4f798d9cb822aac185cc1055ea3438"
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
