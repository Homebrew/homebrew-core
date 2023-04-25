class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.2/llvm-16.0.2.src.tar.xz"
    sha256 "7ace409ccf932052b2587a8774532774b06fa91bc4ce76f55e991396e96f8700"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.2/clang-16.0.2.src.tar.xz"
      sha256 "7e23a207307336ef217e6f55c4501f9b9bd7b8bd80f6dce7148f2a9c028da0fc"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.2/cmake-16.0.2.src.tar.xz"
      sha256 "59c7239ec20c4d0bf3325ed3bb7ec8dad585632b0d9a07f0c2580e1ffe2abb22"
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.2/third-party-16.0.2.src.tar.xz"
      sha256 "3e89b3854056faa02447304010e9198e0f3f63539e0d4cb2dff4c1ec763cb9b7"
    end
  end

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/llvmorg[._-]v?(\d+(?:\.\d+)+)}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd5fe1d2af15a0fe8b8572812e8a47269c8db6724180e6f8e0d23005ea38f230"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35df5fb92dba0a0e904aaed82dd9c8bdf0182b01f543ce9ed252b150975fcd06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c17f023a673c9a0379373c8ae270725b6a642d8ffbbc42f5ca6bf7c5ffd42c39"
    sha256 cellar: :any_skip_relocation, ventura:        "7a92a54ec0c8009617e2290b5841859deac7b2ef2c21efb8e32c64a51e85375c"
    sha256 cellar: :any_skip_relocation, monterey:       "f88b6cd4cc2178556eba58cdfc74433af3f5015940bae6ed6446d032062dea16"
    sha256 cellar: :any_skip_relocation, big_sur:        "2eea3bcd4ccfd322e6e1e4c1fe5f50e379e56947c2431b92b95bf850414f22ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfcf44abe41d4fc3fdfa1fc44b24724e388157da588976c62bd5dd2b071cc9e4"
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
