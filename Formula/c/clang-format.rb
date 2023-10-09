class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.2/llvm-17.0.2.src.tar.xz"
    sha256 "61dd9eaa1f874a10a51dc397b84998eaebdd3c55a5a5fa6c24b2081a435b47c6"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.2/clang-17.0.2.src.tar.xz"
      sha256 "ce1c16b766894b3281038e4b2c4280f1b8c42fd5cc95ba355bba0f5ff47e23fa"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.2/cmake-17.0.2.src.tar.xz"
      sha256 "07093ef3b47bc30c24c8ab4996dea8c89eb6f3c8f55cd43158000c61c1fd5075"
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-17.0.2/third-party-17.0.2.src.tar.xz"
      sha256 "058623c5859c99e6b6711e88c646e80778377ec8e596e1f0e24efb987e063aff"
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1efd2fee1635d34114bd9d6daa1390b66a8df8621feec3c6650d6ef9ba4ade8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd037c2099365c36fe7f98b7a88fd9b38e4e98f176c272ddf647999b52961e68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d6db6df5d9dc8dfe2261d92e24979a7ab95c03ab630696ce000a343f375e262"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe42f4d3a1ae819f7da81d811b06cd3aca135d4169f5f7f0e6643e1ba82ad760"
    sha256 cellar: :any_skip_relocation, ventura:        "dbca4323c6321af28c7c0e15ffc1c9d8d62fb0b8e74709c500d1724d23a292ba"
    sha256 cellar: :any_skip_relocation, monterey:       "e00953e72bf88cd9ec6067d0d6939ec01fe92b555ea00561681ea71ff4556d03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64a41e19b976c1725c0f47d7933c5ff34c153c60b68354a503410e41efbfc5e8"
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
