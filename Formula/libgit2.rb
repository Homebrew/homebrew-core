class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v0.27.4.tar.gz"
  sha256 "0b7ca31cb959ff1b22afa0da8621782afe61f99242bf716c403802ffbdb21d51"
  head "https://github.com/libgit2/libgit2.git"

  bottle do
    cellar :any
    sha256 "9dfc432eeeebbb09ce24b9dadb62e9c45755ee7c4644e3a04801246c48dbe0ed" => :mojave
    sha256 "eaaf186da6c4ee4ba89f2225142a1c9fd52eac009c3666cc23a2d45dbcae9f6a" => :high_sierra
    sha256 "6b4866ccdddc9ddef5267ec2b612c9fc664d96b1495d510b49d0e8d379665579" => :sierra
    sha256 "4808ebcf65a6398a7619ba978e2c27ae195c7a748b3f3596730e004544cd9a61" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "libssh2" => :recommended
  depends_on "openssl" if MacOS.version <= :lion # Uses SecureTransport on >10.7

  def install
    args = std_cmake_args
    args << "-DBUILD_EXAMPLES=YES"
    args << "-DBUILD_CLAR=NO" # Don't build tests.
    args << "-DUSE_SSH=NO" if build.without? "libssh2"

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
