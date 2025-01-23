class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.7/llvm-19.1.7.src.tar.xz"
    sha256 "96f833c6ad99a3e8e1d9aca5f439b8fd2c7efdcf83b664e0af1c0712c5315910"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.7/clang-19.1.7.src.tar.xz"
      sha256 "11e5e4ecab5338b9914de3b83a4622cb200de466b7c56ba675afb72fa7d64675"

      livecheck do
        formula :parent
      end
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.7/cmake-19.1.7.src.tar.xz"
      sha256 "11c5a28f90053b0c43d0dec3d0ad579347fc277199c005206b963c19aae514e3"

      livecheck do
        formula :parent
      end
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.7/third-party-19.1.7.src.tar.xz"
      sha256 "b96deca1d3097c7ffd4ff2bb904a50bdd56bec7ed1413ffb0d1d01af87b72c12"

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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a91e90616edab91fd359f4a6fc8bd6d9d3cd259255b584dc889b8f6b2c89dd9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "53556c40c655edc50e7864bf3766d8a2d545f049945df150c5e24a8e74f320a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85715c4ca65c168d76fb656537e6f0379ac744dd16353f4eae44367fc2c3622e"
    sha256 cellar: :any_skip_relocation, sonoma:        "95843a920960a90a199ff4e66fb571a12a6c76bdac79406e220d2c24d2a049eb"
    sha256 cellar: :any_skip_relocation, ventura:       "c6c2bced5a74c9ad9e6c585a1501b7443562e1aa9a43e6930fe1e7db94c8a7d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75fb6adf42f0ed029ec2f93e977e6d0e0e38cc5c8199d6406c688c350818ffc6"
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
