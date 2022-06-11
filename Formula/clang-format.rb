class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.5/llvm-14.0.5.src.tar.xz"
    sha256 "234c8ed02ed1338aa4f0ffa955e45eb13abe7ba0032569d6bc17ae9334257b02"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.5/clang-14.0.5.src.tar.xz"
      sha256 "a8e2e3ce217f4c2682c3fe2d2691f826cf1f0ab0a1dff4b5b8f6264baa1f2a79"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/llvmorg[._-]v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70bda35ddab5bd3bacc8a643aad68bff985543abaf0ed9b87fcd25a650c1fa82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48477c9781ee49665fd2fa39639c375e50ca628ab708c0e20f6dc1295cb4df5a"
    sha256 cellar: :any_skip_relocation, monterey:       "8492cd3bfbda0866219e81f7f03dc07d3c1ee5849bc2476b832f744b5244b18a"
    sha256 cellar: :any_skip_relocation, big_sur:        "59f192fa04104e53221cf27bd4b0c148352bbc8b529c0ba70e721af4b8825488"
    sha256 cellar: :any_skip_relocation, catalina:       "34561a6a8a523dc514cadc32e145599fdb3c86bded4a3a414604ee3e64a50e8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2b023eb0918fe1b5848f5f879e5e5b7ecadf84da1ec136f81fc001bd34550bd"
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
