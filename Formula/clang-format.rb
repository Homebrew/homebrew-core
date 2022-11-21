class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.5/llvm-15.0.5.src.tar.xz"
    sha256 "4428688b567ab1c9911aa9e13cb44c9bc1b14431713c14de491e10369f2b0370"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.5/clang-15.0.5.src.tar.xz"
      sha256 "3737d1d81253bc7608443661ac616bdc06f8833d313f4c3e22ed0eecc55b1238"
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.5/cmake-15.0.5.src.tar.xz"
      sha256 "61a9757f2fb7dd4c992522732531eb58b2bb031a2ca68848ff1cfda1fc07b7b3"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/llvmorg[._-]v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8440d45e0d4fc5a8e1a71d8363f730a02877494b4a992b7e7882653bf659dc37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8d9838547a6eae654e7b9b844ee68ec098ee68a6375256ddd94d1a7417de1f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0d832123d1eaec83e9ea215f30583c6507f989a8863f4f53093a431cdb87c75"
    sha256 cellar: :any_skip_relocation, monterey:       "836b73c2885e669bc5246a503ee428cac13a48036f9c2bc10d83b4e0a30943c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "af1b727ec326c353fee089fd0115a5657aec0933ab6a5d37a80cbec833124da9"
    sha256 cellar: :any_skip_relocation, catalina:       "b09f4a2d5c6b8d1bb5067ae094187c8f162d89b9809405b89a76038a0ceba84d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25cd6402256e3b3dc0dd668fd11cdb73253873d3e5cfd32316069e56aab6d1a9"
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
