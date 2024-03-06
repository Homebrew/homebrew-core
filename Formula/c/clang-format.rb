class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.0/llvm-18.1.0.src.tar.xz"
    sha256 "b83af9ed31e69852bb5f835b597f8e769a0707aea89a3097d4fc8e71e43f2a1a"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.0/clang-18.1.0.src.tar.xz"
      sha256 "c5cb0cedec2817914e66bb86ea4c6588ddf53b183e89b2997741d005f9553cbe"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.0/cmake-18.1.0.src.tar.xz"
      sha256 "d367bf77a3707805168b0a7a7657c8571207fcae29c5890312642ee42b76c967"
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.0/third-party-18.1.0.src.tar.xz"
      sha256 "5028eb1d6baa7b59cc88b2180467ea67ff2d5d4acdf095b530260d9d8868c16b"
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1bb881df31b9f0dd6a85ef97572b31bf8292aa7d05d8f35d49bc830424b3011b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7835985d5e6edfb05205883c484135120789c78bc3b5eeeddc39d7b5170c6b16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67fbefb432b2cc11d08c14ffb89cb71b1026a83b81c2e7fac089663a053b64c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "e11bb2ee8e4012e08afeb1c2109af21feba56e7225ff6e473e69c8ad2aed36ea"
    sha256 cellar: :any_skip_relocation, ventura:        "fcb5fe00f5fca01bbe9aae794a6d4c3459effce8f9906445f44d2991fece69ae"
    sha256 cellar: :any_skip_relocation, monterey:       "1ea4441a6fc772efe6eed7a3e64ca74229753eb2b0d66f5b81ead8eed3ae973e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35e9c5cc360ace20a6eaa5ee6c1956ba93e32faf67834e4c931f60277f590724"
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
