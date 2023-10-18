class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.3/llvm-17.0.3.src.tar.xz"
    sha256 "18fa6b5f172ddf5af9b3aedfdb58ba070fd07fc45e7e589c46c350b3cc066bc1"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.3/clang-17.0.3.src.tar.xz"
      sha256 "605a6a091e9d14721ba00048b7409fb73119a60756c959a19a177c8e057d947c"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.3/cmake-17.0.3.src.tar.xz"
      sha256 "54fc534f0da09088adbaa6c3bfc9899a500153b96e60c2fb9322a7aa37b1027a"
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.3/third-party-17.0.3.src.tar.xz"
      sha256 "6e84ff16044d698ff0f24e7445f9f47818e6523913a006a5e1ea79625b429b7b"
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88fe7ab9e45a771fe78c915bf4a13cfea7da29c5a2ce7f56061d967a2248fa7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6434fe4684f9be5700bd93392f39b0dd2b1802bd89a1b4fade2beae43b2e579"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa8152d605ef84b567c7c91343a01f1e0a558f43b6799df5a942e049a3826db5"
    sha256 cellar: :any_skip_relocation, sonoma:         "558573ffa9b8295dfda5224807b5a6b919335ad31a1905fbb74e085c94155848"
    sha256 cellar: :any_skip_relocation, ventura:        "5ceca5c06792b6ccebd1ef92b2a08bfb8d38d28b4359953f586193ca63c1bd64"
    sha256 cellar: :any_skip_relocation, monterey:       "cd435f7b1a7104323df8561fdab560ec981efda0100074e54cba90439b2384e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31c4885de4af5b78c6865db8532e84f23f0b2c836acc7d2cbdd377da52b7bba2"
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
