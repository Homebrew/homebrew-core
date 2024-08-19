class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.8/llvm-18.1.8.src.tar.xz"
    sha256 "f68cf90f369bc7d0158ba70d860b0cb34dbc163d6ff0ebc6cfa5e515b9b2e28d"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.8/clang-18.1.8.src.tar.xz"
      sha256 "5724fe0a13087d5579104cedd2f8b3bc10a212fb79a0fcdac98f4880e19f4519"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.8/cmake-18.1.8.src.tar.xz"
      sha256 "59badef592dd34893cd319d42b323aaa990b452d05c7180ff20f23ab1b41e837"
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.8/third-party-18.1.8.src.tar.xz"
      sha256 "b76b810f3d3dc5d08e83c4236cb6e395aa9bd5e3ea861e8c319b216d093db074"
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6f9a261484afa3a336c77cbf026b3e2f24c4ef5247e2179598c5e0b6f4de2c48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ea1ac8ea7cdc00dd98ef40cb19d6f206b1c0e0874e4a41543d967fb7a883bb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b06e209a1bd526599f634e97ff41f7a9bf01d9498f64b32ee6ea2eeebc65bab"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6ca9b11944c9babb5ae0535a69e45ceee868ae2407b2a8fd3be99ad559bd94a"
    sha256 cellar: :any_skip_relocation, ventura:        "076c269305fe377fe1feb374fed85ebe94730791a41d4611df30d799585ace32"
    sha256 cellar: :any_skip_relocation, monterey:       "0c46df83b0fcc7c94a22c7caa17c95a41964d36edb461773c93b00e160f2ab6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f82f4f4a721d3776c85941a9bd78b546ab6c0d50ec35d5346186b5f5d4c1d7f"
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
