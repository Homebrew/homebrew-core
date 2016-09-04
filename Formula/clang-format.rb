class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "http://clang.llvm.org/docs/ClangFormat.html"
  version "2016-08-03"

  stable do
    url "http://llvm.org/svn/llvm-project/llvm/tags/google/testing/2016-08-03/", :using => :svn

    resource "clang" do
      url "http://llvm.org/svn/llvm-project/cfe/tags/google/testing/2016-08-03/", :using => :svn
    end

    resource "libcxx" do
      url "http://llvm.org/releases/3.9.0/libcxx-3.9.0.src.tar.xz"
      sha256 "d0b38d51365c6322f5666a2a8105785f2e114430858de4c25a86b49f227f5b06"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1a74c2aa6b25f0e48bd66afa84e2df6c84eabd95341e28018024e5eb02afd465" => :el_capitan
    sha256 "e3a27ce32057786d6f953d9f2c31d81b36dd8e11d3bfe7dd90d76acc9ca6df9d" => :yosemite
    sha256 "a18e94ffe60e9bf56840cf5861febca2e3c6ca556bec411dfd29851b8c089ca4" => :mavericks
  end

  head do
    url "http://llvm.org/svn/llvm-project/llvm/trunk/", :using => :svn

    resource "clang" do
      url "http://llvm.org/svn/llvm-project/cfe/trunk/", :using => :svn
    end

    resource "libcxx" do
      url "http://llvm.org/releases/3.9.0/libcxx-3.9.0.src.tar.xz"
      sha256 "d0b38d51365c6322f5666a2a8105785f2e114430858de4c25a86b49f227f5b06"
    end
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "subversion" => :build

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
    (testpath/"test.c").write <<-EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")
  end
end
