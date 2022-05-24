class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.3/llvm-14.0.3.src.tar.xz"
    sha256 "1e09e8c26e1b67bc94a128b62e9b9c24b70c697a2436a479c9e5eedc4ae29654"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.3/clang-14.0.3.src.tar.xz"
      sha256 "f85c55f192cb35b9d6af1f998b7d5abe90e369f8b16445503ffab1b02e75a6f0"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/llvmorg[._-]v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d518dd0e091e3b69749526051078ab376ab5001d1b538feeee1f4120676c3959"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4e65516e38bbce07b2300041a780d6ac9642a6a9e199e899873a36bb0831471"
    sha256 cellar: :any_skip_relocation, monterey:       "66d3afce9d3fa6417f5dcf8d2082cf46903ea6409a9951f1c8efe3428d7d477f"
    sha256 cellar: :any_skip_relocation, big_sur:        "58b0ed6c859d751ac4b5fe64da0e3674b37ee96010afe742e66bb7fbdf528af4"
    sha256 cellar: :any_skip_relocation, catalina:       "3f83410a029227830f4b4847f2d1323ae0b123e6ff1447e3ca897d938c32c0d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3f34b9b0e06f8cb0f5cf877c82ae9138def15fcd92566876e92f9f03d1154b1"
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
