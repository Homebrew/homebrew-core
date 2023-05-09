class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.3/llvm-16.0.3.src.tar.xz"
    sha256 "d820e63bc3a6f4f833ec69a1ef49a2e81992e90bc23989f98946914b061ab6c7"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.3/clang-16.0.3.src.tar.xz"
      sha256 "5fa9a398a7d3274d1d38e9f7c01c068f7d6d80f08de45d01c40f7177cdb20097"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.3/cmake-16.0.3.src.tar.xz"
      sha256 "b6d83c91f12757030d8361dedc5dd84357b3edb8da406b5d0850df8b6f7798b1"
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.3/third-party-16.0.3.src.tar.xz"
      sha256 "b964f570b6fb08da2e8f6570797e656dfa208b99c05ae92e4bfeffcfeaddd2b8"
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27ec0749588805607971028df71c4a9deffe7f7045d5f5073bacd9c6939f0416"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2042af5f3da3ee949b30d8a55169f183fcabf91e8cdabdbf752ea890c73839e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12a91c7ebc1e3831e6f24d2e59fd00f2e4535dc97355a7d96e417c0cbba806d9"
    sha256 cellar: :any_skip_relocation, ventura:        "b2da2d2df9f700aa55e732a22f88e7586bb8f6a91724d815bad9e2f77e17b9b1"
    sha256 cellar: :any_skip_relocation, monterey:       "983ca202530661aeaa1eb21e4a05a06658fc792c7cdcf48ec0af767149c47470"
    sha256 cellar: :any_skip_relocation, big_sur:        "099953f96c59fc7431e7f0c96cfd75b37637f0ad3bbf5e595b779c8cc8abc817"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96568c42132bf52db966084f27759ab4874db997c8e1a68923e65818ceb544b2"
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
