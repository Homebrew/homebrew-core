class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.0/llvm-14.0.0.src.tar.xz"
    sha256 "4df7ed50b8b7017b90dc22202f6b59e9006a29a9568238c6af28df9c049c7b9b"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.0/clang-14.0.0.src.tar.xz"
      sha256 "f5d7ffb86ed57f97d7c471d542c4e5685db4b75fb817c4c3f027bfa49e561b9b"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/llvmorg[._-]v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "516220de6b79f1294dda371e4109f589e04e9031b33d98a8c84f81be2dc9a8de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d553a5b9b8545888b2b0c761fa467f9246889829af22d17d1825db5b03f9f7a"
    sha256 cellar: :any_skip_relocation, monterey:       "0acb8fbdf0688d6a635d231bf9edf8be5951d7466eb36bb6dda1166850e5e800"
    sha256 cellar: :any_skip_relocation, big_sur:        "95a078766d73d0d080c6320c694abdcde02bc628befcf6f9c440e72e60835e42"
    sha256 cellar: :any_skip_relocation, catalina:       "e17531e7556455d928c7d1e24c83f7a74b99b013dc59fae28c80b8ccc26c853d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "259aeed9d99208bd1513f5c4977984c5b049bcb7199fd17b724a695c33464ad8"
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
