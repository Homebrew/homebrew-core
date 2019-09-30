class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v0.28.3.tar.gz"
  sha256 "ee5344730fe11ce7c86646e19c2d257757be293f5a567548d398fb3af8b8e53b"
  head "https://github.com/libgit2/libgit2.git"

  bottle do
    cellar :any
    sha256 "6608663c6570504f2e660bb42053e2f635573605dd84f9f7f0edaa3b84ab8fd5" => :catalina
    sha256 "0fba4d5f2cb883e1d51b59a8b3fd5751da5ba84f908e336c6836ba9758bdac17" => :mojave
    sha256 "369187dd0615fedd7748f681047d5d28cfe1bba7bcea4d5345b53524e64e03c5" => :high_sierra
    sha256 "ee851d8551c03dbe9d265adb57f1a0069bb6114534bfbcd128034e15f9fdf5a6" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libssh2"

  def install
    args = std_cmake_args
    args << "-DBUILD_EXAMPLES=YES"
    args << "-DBUILD_CLAR=NO" # Don't build tests.

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      cd "examples" do
        (pkgshare/"examples").install "add", "blame", "cat-file", "cgit2",
                                      "describe", "diff", "for-each-ref",
                                      "general", "init", "log", "remote",
                                      "rev-list", "rev-parse", "showindex",
                                      "status", "tag"
      end
      system "make", "clean"
      system "cmake", "..", "-DBUILD_SHARED_LIBS=OFF", *args
      system "make"
      lib.install "libgit2.a"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <git2.h>

      int main(int argc, char *argv[]) {
        int options = git_libgit2_features();
        return 0;
      }
    EOS
    libssh2 = Formula["libssh2"]
    flags = %W[
      -I#{include}
      -I#{libssh2.opt_include}
      -L#{lib}
      -lgit2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
