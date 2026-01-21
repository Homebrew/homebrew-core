class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/llvm-21.1.8.src.tar.xz"
    sha256 "d9022ddadb40a15015f6b27e6549a7144704ded8828ba036ffe4b8165707de21"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/clang-21.1.8.src.tar.xz"
      sha256 "6090e3f23720d003cdd84483a47d0eec6d01adbb5e0c714ac0c8b58de546aa62"

      livecheck do
        formula :parent
      end
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/cmake-21.1.8.src.tar.xz"
      sha256 "85735f20fd8c81ecb0a09abb0c267018475420e93b65050cc5b7634eab744de9"

      livecheck do
        formula :parent
      end
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.8/third-party-21.1.8.src.tar.xz"
      sha256 "7fe99424384aea529ffaeec9cc9dfb8b451fd1852c03fc109e426fe208a1f1a7"

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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26dc592e1f1a8d9dd7923e12c7b080228f273f9eaca9032d7a259e72c4f6c227"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "242cf67bb85e7d28a372a94cc60419c6b9f76833ab5a89a23c068b5cad14ce83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d23e383f618a00829edcdefcf5dba6ed540ebd6b5da0c6760aebeff6f13625ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "299fb37203ee17a13e20d11a10a7796ec25ba96f64819f9cbef62dfe44a154c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "104f6d0e6e8b740b897ebbb60b7cd3ecc6f725f65169c49f8abeb7ad61d125ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30bcb264a642475ac34734670e548874eaaa46ba1204a0f276befe835b510559"
  end

  depends_on "cmake" => :build

  uses_from_macos "python"

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

    assert_equal "int main(char* args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")

    ENV.prepend_path "PATH", bin
    assert_match "test.c", shell_output("git clang-format", 1)
  end
end
