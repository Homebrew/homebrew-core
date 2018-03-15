class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  version "2018-01-11"

  stable do
    if MacOS.version >= :sierra
      url "https://llvm.org/svn/llvm-project/llvm/tags/google/stable/2018-01-11/", :using => :svn
    else
      url "http://llvm.org/svn/llvm-project/llvm/tags/google/stable/2018-01-11/", :using => :svn
    end

    resource "clang" do
      if MacOS.version >= :sierra
        url "https://llvm.org/svn/llvm-project/cfe/tags/google/stable/2018-01-11/", :using => :svn
      else
        url "http://llvm.org/svn/llvm-project/cfe/tags/google/stable/2018-01-11/", :using => :svn
      end
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a8a1eb007f7828790a1605d2647e6848e1f9617c26c8d31bfcf56a075a20bafb" => :high_sierra
    sha256 "b4db7e4f2623195adaa475b0d5567de7fe3c1bb70449b35888aea69136c66931" => :sierra
    sha256 "30767fb6f85073ac7fc58a2d80135c52623d76c9f594087b489164e0df6f901c" => :el_capitan
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
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "subversion" => :build

  resource "libcxx" do
    url "https://releases.llvm.org/5.0.0/libcxx-5.0.0.src.tar.xz"
    sha256 "eae5981e9a21ef0decfcac80a1af584ddb064a32805f95a57c7c83a5eb28c9b1"
  end

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
