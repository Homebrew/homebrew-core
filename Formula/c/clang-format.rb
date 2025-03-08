class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.0/llvm-20.1.0.src.tar.xz"
    sha256 "29a42977809cb5e1c076e4495a79dc86b17386e5ab9fa4ca1a580aeb0a2ece5e"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.0/clang-20.1.0.src.tar.xz"
      sha256 "fa505976804aad1625406b6df69ab2dd94b9a98a2c3abab10f1e7fc1d53853fe"

      livecheck do
        formula :parent
      end
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.0/cmake-20.1.0.src.tar.xz"
      sha256 "9fcd319c6bb87344673f262ef5a6a01262fc9a0a741f3477b7e47e238441268d"

      livecheck do
        formula :parent
      end
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.0/third-party-20.1.0.src.tar.xz"
      sha256 "d647982936703680e9e0e52bbfb2d67fa293db008a23e1e148ea511e917c2208"

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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e5cdcdf1e22df62b7806cb80cbc779c4e9fbbad331423bc31dfa2d9068d2697"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de7930fa626660c7e81f7fd11338852d263cf539cbf7942c0f578a99361a68c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c148e05774a06dc7e0794a669a6c9b2c2c5a024bb592e19fb6c28fb27b645bd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "167a106fa82e4bf55c2273df67d0074943961cc57fcaa4c4475baee4a8cd9968"
    sha256 cellar: :any_skip_relocation, ventura:       "6b4be5044fe44db05c7e0d1f5308efd6587fc302025ea68deb47a6b3a2480bc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e5caccc2fb7ce6b746d410e880db69169e44057bc0a0f620cdc0c0d0483bdf0"
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
