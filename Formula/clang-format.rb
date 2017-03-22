class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  version "2017-03-17"

  stable do
    if MacOS.version >= :sierra
      url "https://llvm.org/svn/llvm-project/llvm/tags/google/stable/2017-03-17/", :using => :svn
    else
      url "http://llvm.org/svn/llvm-project/llvm/tags/google/stable/2017-03-17/", :using => :svn
    end

    resource "clang" do
      if MacOS.version >= :sierra
        url "https://llvm.org/svn/llvm-project/cfe/tags/google/stable/2017-03-17/", :using => :svn
      else
        url "http://llvm.org/svn/llvm-project/cfe/tags/google/stable/2017-03-17/", :using => :svn
      end
    end

    resource "libcxx" do
      url "http://llvm.org/releases/4.0.0/libcxx-4.0.0.src.tar.xz"
      sha256 "4f4d33c4ad69bf9e360eebe6b29b7b19486948b1a41decf89d4adec12473cf96"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8ba03b3ca6baf6b5bc29dcb5d62dc8d9a4b5e9baffbf6b3289db7018e378d0e2" => :sierra
    sha256 "c426bb3d06a164940625c59fe848dd7f7bb77f80ef2d2bcc007d73a86c1c81e5" => :el_capitan
    sha256 "e4fa1db39665664088b2e4c0926013e5e8c1e09abaddea5615faf232fd815f9c" => :yosemite
  end

  head do
    if MacOS.version >= :sierra
      url "https://llvm.org/svn/llvm-project/llvm/trunk/", :using => :svn
    else
      url "http://llvm.org/svn/llvm-project/llvm/trunk/", :using => :svn
    end

    resource "clang" do
      if MacOS.version >= :sierra
        url "https://llvm.org/svn/llvm-project/cfe/trunk/", :using => :svn
      else
        url "http://llvm.org/svn/llvm-project/cfe/trunk/", :using => :svn
      end
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
