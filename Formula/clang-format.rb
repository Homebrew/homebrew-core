class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.1/llvm-16.0.1.src.tar.xz"
    sha256 "17d2142be9ff75c31ad76c53af7409974842545b94aaeac17f38b3b8567b0582"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.1/clang-16.0.1.src.tar.xz"
      sha256 "20cb1413846d75a5f57c7209f441801b63df38360142d98bf2b3dd3865301a91"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.1/cmake-16.0.1.src.tar.xz"
      sha256 "f7b070b0ea71251c81b1a3dcdc6ccd28f59615e3e386c461456c5c246406acdc"
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.1/third-party-16.0.1.src.tar.xz"
      sha256 "08ea121e31b0c6a6e81c811aacc0326dc1e06eb4919b2ac4c8d26f5016d9bb0a"
    end
  end

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/llvmorg[._-]v?(\d+(?:\.\d+)+)}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbca9b47fcd77a077009c3a621317f6d71a5a9405b26eaf8d520d744d772f8fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac7f3d41d27ee7d73a4b6cde1a4846f804521aa2e0d760081665054336789c37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1dbdbf41154048fed19dadab9e2dc0ddba8f00abf9ac9087bbeb7aa8c3558a9c"
    sha256 cellar: :any_skip_relocation, ventura:        "4cb18af7045788305bf95f884d6b8c92dd9531a5c516b353b9be9e660d69cebe"
    sha256 cellar: :any_skip_relocation, monterey:       "c0e6a1315527c5288357b75f40c21878dd247a34c73305d51a5d63b44b6cdeb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ba739d546f0c4e0393ff109b7db573b9e3aa810ceaabe4d6149dfefff758791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea55aa3ee0174aac67d9b782636eb6999746f909b0bbbfdf2c14c4cfa1b1bb76"
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
