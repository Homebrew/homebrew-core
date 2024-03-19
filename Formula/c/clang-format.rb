class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.1/llvm-18.1.1.src.tar.xz"
    sha256 "ab0508d02b2d126ceb98035c28638a9d7b1e7fa5ef719396236e72f59a02e1ac"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.1/clang-18.1.1.src.tar.xz"
      sha256 "412a482b81a969846b127552f8fa2251c7d57a82337f848fe7fea8e6ce614836"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.1/cmake-18.1.1.src.tar.xz"
      sha256 "5308023d1c1e9feb264c14f58db35c53061123300a7eb940364f46d574c8b2d6"
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.1/third-party-18.1.1.src.tar.xz"
      sha256 "41cdf4fe95faa54f497677313b906e04e74079a03defa9fdc2f07ed5f259f1ef"
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22baea59bcb8673ca9ff58e9ca0fff8614db60af0b7cd19d5e7b8c6fa6e2ba61"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d1b0d2fec9d5f0b64031b0a5a93723135bfabc5c163c402ec1bdef407a233fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7210cc68c0cb6c336540ae505c8fb7412b858ca6fe540780c5e7a6eb49b13bbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "80cfc3957663b6d698c1bb3a68c0299e31f82f521843af4f2246021b6195be25"
    sha256 cellar: :any_skip_relocation, ventura:        "caded119a2279c7eafbab496ec1b30f7a3fa5ee9040ac379af670b0cccebf413"
    sha256 cellar: :any_skip_relocation, monterey:       "dc43892dca58b368de799f88700c0da45c9cf15137197979e15d2888c340c67f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73335e416f6c905d6b730a63be98df4866a1e4ceeeae2b044089790ed2f829a9"
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
