class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  version "2019-05-14"

  stable do
    depends_on "subversion" => :build
    url "https://llvm.org/svn/llvm-project/llvm/tags/google/stable/2019-05-14/", :using => :svn

    resource "clang" do
      url "https://llvm.org/svn/llvm-project/cfe/tags/google/stable/2019-05-14/", :using => :svn
    end

    resource "libcxx" do
      url "https://releases.llvm.org/9.0.0/libcxx-9.0.0.src.tar.xz"
      sha256 "3c4162972b5d3204ba47ac384aa456855a17b5e97422723d4758251acf1ed28c"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "811e557c5b540317ff532959f3b074d6b9763abfb58186f3a1cbeb10acfb3358" => :catalina
    sha256 "beb4842dafb9092fe56ba4dc94030b581d3ae85ae914b2c2a37ae872c88dbd34" => :mojave
    sha256 "dcea54b1734a2385a7275deb7b7fe9970cf06387d9051103476a0082614849f0" => :high_sierra
  end

  head do
    url "https://git.llvm.org/git/llvm.git"

    resource "clang" do
      url "https://git.llvm.org/git/clang.git"
    end

    resource "libcxx" do
      url "https://git.llvm.org/git/libcxx.git"
    end
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    (buildpath/"projects/libcxx").install resource("libcxx")
    (buildpath/"tools/clang").install resource("clang")

    mkdir "build" do
      args = std_cmake_args
      args << "-DCMAKE_OSX_SYSROOT=/" unless MacOS::Xcode.installed?
      args << "-DLLVM_ENABLE_LIBCXX=ON"
      args << ".."
      system "cmake", "-G", "Ninja", *args
      system "ninja", "clang-format"
      bin.install "bin/clang-format"
    end
    bin.install "tools/clang/tools/clang-format/git-clang-format"
    (share/"clang").install Dir["tools/clang/tools/clang-format/clang-format*"]
  end

  test do
    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")
  end
end
