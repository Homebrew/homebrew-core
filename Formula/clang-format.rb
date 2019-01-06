class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  version "2018-10-04"

  stable do
    depends_on "subversion" => :build
    url "http://llvm.org/svn/llvm-project/llvm/tags/google/stable/2018-10-04/", :using => :svn

    resource "clang" do
      url "http://llvm.org/svn/llvm-project/cfe/tags/google/stable/2018-10-04/", :using => :svn
    end

    resource "libcxx" do
      url "https://releases.llvm.org/7.0.0/libcxx-7.0.0.src.tar.xz"
      sha256 "9b342625ba2f4e65b52764ab2061e116c0337db2179c6bce7f9a0d70c52134f0"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "28b91825e07d1226b5e380613ab56548c0422f9afa5201295f8e743aad30ccc1" => :mojave
    sha256 "ad3674897a21263f6fb7f7fbef4db9e85908f97520de1b6d27bcf7f39d67eac9" => :high_sierra
    sha256 "00664db0aaf542bda425318369391787a9decb0179cb845b42539f15001bdf27" => :sierra
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
