class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.1/llvm-21.1.1.src.tar.xz"
    sha256 "23336f9f2290f2317121a5995e298a4616041ba06cbb07cfd1220a21b48775fe"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.1/clang-21.1.1.src.tar.xz"
      sha256 "65a19a75440c6d0f92138d82432e7a201677fad5cecf39d3200eaa2f458c29e3"

      livecheck do
        formula :parent
      end
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.1/cmake-21.1.1.src.tar.xz"
      sha256 "9c0b9064b7d0f2a3004f1d034aadf84d2af4e5dca2135ebf697b0a1eb85ef769"

      livecheck do
        formula :parent
      end
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.1/third-party-21.1.1.src.tar.xz"
      sha256 "e9b7299b0b32aa827231ed35101a3b5ea37dd5a45719225cb2c08ac571791233"

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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "014ebac188ed135eec2eb15205c562c5af2adfa0a2e55ccef9e14adf9af06da3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dc4f9fd509edbf95eb38bca27d0b33517f121ede71f686b1a66bfd4bf2104a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a88e8c73561296e734433e2cefb6d1d97423ecd63f2fe807e416222f0643d3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ed7e7f2e37d9bb4f92e5ad7dbe5bb235269cafd061f52e32d6bb05e2a320270"
    sha256 cellar: :any_skip_relocation, sonoma:        "04ee3e28f1ff2c006151a9eaf378dcd750dd4dde981aed0b87eff1c054b44def"
    sha256 cellar: :any_skip_relocation, ventura:       "06f4e98f3fbddfb6c8cd982a0adb1a2bc257b3da16e1fadd9ec3d3acb5343516"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5afaa16c7f0fb2decef4e3c50b7a2f92cf8260c04fa6f84d29e9d1dd0a3cd00a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a20b3f4306b61f48c53135a3632081f73dfa18278460363b09daebb2ba0851f"
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

    assert_equal "int main(char* args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")

    ENV.prepend_path "PATH", bin
    assert_match "test.c", shell_output("git clang-format", 1)
  end
end
