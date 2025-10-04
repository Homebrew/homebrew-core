class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.2/llvm-21.1.2.src.tar.xz"
    sha256 "07656950a7081e3d8a0b8b6dd07926fad2458996c1c6bbfea1bd2529ed4c2798"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.2/clang-21.1.2.src.tar.xz"
      sha256 "5050e2028bb4d7ca80aadc6f4ae84d15b73747880520957ae1e907065a406c10"

      livecheck do
        formula :parent
      end
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.2/cmake-21.1.2.src.tar.xz"
      sha256 "9ccbaf5ed6bb9e0bcedd827a433fb8f73878b64556bbc1da1e17d88ec0bde0cc"

      livecheck do
        formula :parent
      end
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-21.1.2/third-party-21.1.2.src.tar.xz"
      sha256 "106f56f6d249bdd7f9c50316dd37b509c06f0c1cff658abe7dfbc08a91a109f2"

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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1352a666412ac474bb832b914b33cb5d06609c027be529c0a01c4f7eb91c46a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bc62bab6304951764fb64d7d01eb4b1f27f7ce5172f4265ca7a363fd0451c34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84c7a2f60275517b3f77b1e3ec1576b599f255754f609737a1704efb9ccb5128"
    sha256 cellar: :any_skip_relocation, sonoma:        "5204020b9063d2c967c1d2c977680b5236f5d82f8c2a9102f007f3d17e82f97d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a69bef8e61b2167409eb0affec43dc17e243fe3eb3d0b52e5ae995177c63c6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3443ec27012c4476e07bb26d4a749fa6567708311e487237589e64815da5c1ca"
  end

  depends_on "cmake" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "python"
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
