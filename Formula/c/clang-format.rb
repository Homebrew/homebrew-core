class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  # The LLVM Project is under the Apache License v2.0 with LLVM Exceptions
  license "Apache-2.0" => { with: "LLVM-exception" }
  version_scheme 1
  head "https://github.com/llvm/llvm-project.git", branch: "main"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.4/llvm-20.1.4.src.tar.xz"
    sha256 "98a95e4a86dd50d0177ae058365e08da0569ad843e829a68489a0d217e5c4411"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.4/clang-20.1.4.src.tar.xz"
      sha256 "f26454224190c2090e5d21be8700abbc56592a0c0764291a5c358f2974f1fde3"

      livecheck do
        formula :parent
      end
    end

    resource "cmake" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.4/cmake-20.1.4.src.tar.xz"
      sha256 "d6fe52e4fd709590284127cfef143f67ff1b917865f1b4731f6600c330bf9c27"

      livecheck do
        formula :parent
      end
    end

    resource "third-party" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.4/third-party-20.1.4.src.tar.xz"
      sha256 "94a42d62aaf96b260f01217e170620bd120eaf70926930a58c8c451aceb9c015"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    url :stable
    regex(/llvmorg[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38931f7505bc619f2ae113107e70ccc205983648705b97b68f2231bf08e66aa8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d6d963e75c4830a1085818d7a7f0a9af0e4119c8e83e2e7c094cc52e9cde3c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42f50086c60ec62f9614f212dbb48a9d290befb8fc8d1b3c96003e3ed0a6b08e"
    sha256 cellar: :any_skip_relocation, sonoma:        "73d1da3d3f298ffaf019f0884249f367d0181a0506920b3a42e9b2f948bc8b49"
    sha256 cellar: :any_skip_relocation, ventura:       "8d5ac0202240c7a04af12fc3baa19d4f24e260decd80b7f742387cd57a899c07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8efeb1a953fadf41215d2cc817aa94117a4ff10538ee76f1827c688541982cd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90b6425ed94d758396387c0bf9e62764e2038705729f6b993a6f0d8f6b007938"
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
    odie "clang resource needs to be updated" if build.stable? && version != resource("clang").version
    odie "cmake resource needs to be updated" if build.stable? && version != resource("cmake").version
    odie "third-party resource needs to be updated" if build.stable? && version != resource("third-party").version

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
    (testpath/"test.c").write <<~C
      int         main(char *args) { \n   \t printf("hello"); }
    C
    system "git", "add", "test.c"

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")

    ENV.prepend_path "PATH", bin
    assert_match "test.c", shell_output("git clang-format", 1)
  end
end
