class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  version "2018-08-24"

  stable do
    url "http://llvm.org/svn/llvm-project/llvm/tags/google/stable/2018-08-24/", :using => :svn

    resource "clang" do
      url "http://llvm.org/svn/llvm-project/cfe/tags/google/stable/2018-08-24/", :using => :svn
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4226b7159481b432fafa7883c925c084c63d594e8fde378b741fa1ce5dbcac80" => :mojave
    sha256 "d45589054615e47aca8acc51c84c484a8b3428a3d89079aa19457c3cae475653" => :high_sierra
    sha256 "aab479b0747bb1f48b7efebb1477b6dad2f93a5cabdb44aaf2428d74aea3a6a4" => :sierra
    sha256 "9751ab418b3b7760513b3e56e97c705f9fda45b84a4885cf1ce21fbf81dcd8a3" => :el_capitan
  end

  head do
    url "http://llvm.org/svn/llvm-project/llvm/trunk/", :using => :svn

    resource "clang" do
      url "http://llvm.org/svn/llvm-project/cfe/trunk/", :using => :svn
    end
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "subversion" => :build

  resource "libcxx" do
    url "https://releases.llvm.org/7.0.0/libcxx-7.0.0.src.tar.xz"
    sha256 "9b342625ba2f4e65b52764ab2061e116c0337db2179c6bce7f9a0d70c52134f0"
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
