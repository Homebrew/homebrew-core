class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.5/llvm-16.0.5.src.tar.xz"
    sha256 "701b764a182d8ea8fb017b6b5f7f5f1272a29f17c339b838f48de894ffdd4f91"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.5/clang-16.0.5.src.tar.xz"
      sha256 "f4bb3456c415f01e929d96983b851c49d02b595bf4f99edbbfc55626437775a7"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.5/cmake-16.0.5.src.tar.xz"
      sha256 "9400d49acd53a4b8f310de60554a891436db5a19f6f227f99f0de13e4afaaaff"
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.5/third-party-16.0.5.src.tar.xz"
      sha256 "0a4bbb8505e95570e529d6b3d5176e93beb3260f061de9001e320d57b59aed59"
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4999701a9b9b1eb6c77a932a3ad4a9cdad3b48e5df2710fbe2245aa4ebef0e74"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d97ee31e129cfb18880bc07055fdea534b1249b6fc8d7112fda193d5747e0dc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df7d7feaac7fae25eab0ce65e041b565afc4e7d8cd5e1fac8df760c0871ccb69"
    sha256 cellar: :any_skip_relocation, ventura:        "24289ea7db364c5bd80436b23d6b57ff2eceadb6eb2d642c4923a06a3d7e0991"
    sha256 cellar: :any_skip_relocation, monterey:       "ea03ccb84e28e3dc33ce784a46c370541dedf384f6cf0a0b6c92516428b089f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9a8507efa7f62a1cdff91a72aebe8e431ae5fdc31d57b2cdaf0bc151bdd7b2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe95f8c1dc10e48d20124d8eb1c5b7c15424a50589f79d1bbccd07718bfd5406"
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
