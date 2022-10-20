class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.6/llvm-14.0.6.src.tar.xz"
    sha256 "050922ecaaca5781fdf6631ea92bc715183f202f9d2f15147226f023414f619a"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.6/clang-14.0.6.src.tar.xz"
      sha256 "2b5847b6a63118b9efe5c85548363c81ffe096b66c3b3675e953e26342ae4031"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/llvmorg[._-]v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f25fa006c4f3684d7cc403d81f3dbbd00aef5dcee54d8909fc0b929dc46fd21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f1cebeec140ce27dbbf0f9b7ffde342ad1a7d7ae90476e2d8ecf659e44cc8c3"
    sha256 cellar: :any_skip_relocation, monterey:       "7185911bd8c322d7b88340b6a2479454271609d6356c86538c2e2fb7c037950d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ce43d5e2e82cdbc41d8dffed41d389c7876509109911132a1a206dd5324eeef"
    sha256 cellar: :any_skip_relocation, catalina:       "5c8b3a8d0fecfed6220b2e97ea818452160fa0e6af03260f350a613e42fd242a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "201ae67f25cbb2a92d024a40bccf978f8f8b165cad149eabf8dc8f701ff33347"
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
      resource("clang").stage do |r|
        (buildpath/"llvm-#{version}.src/tools/clang").install Pathname("clang-#{r.version}.src").children
      end

      buildpath/"llvm-#{version}.src"
    end

    system "cmake", "-S", llvmpath, "-B", "build",
                    "-DLLVM_EXTERNAL_PROJECTS=clang",
                    "-DLLVM_INCLUDE_BENCHMARKS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build", "--target", "clang-format"

    git_clang_format = llvmpath/"tools/clang/tools/clang-format/git-clang-format"
    inreplace git_clang_format, %r{^#!/usr/bin/env python$}, "#!/usr/bin/env python3"

    bin.install "build/bin/clang-format", git_clang_format
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
    assert_match "test.c", shell_output("git clang-format")
  end
end
