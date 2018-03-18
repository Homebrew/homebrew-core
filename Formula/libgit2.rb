class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v0.26.3.tar.gz"
  sha256 "0da4e211dfb63c22e5f43f2a4a5373e86a140afa88a25ca6ba3cc2cae58263d2"
  head "https://github.com/libgit2/libgit2.git"

  bottle do
    sha256 "d65cbc0cd61400e9146a8b5902a340093aa2a488ed78e7d98562f3742c5ed8b3" => :high_sierra
    sha256 "c15620661180e29df16c5061f8b3a692f14c33624584ce6ca69ae0050e99c840" => :sierra
    sha256 "1ef3c29008e961a6b739a7658fe30aaa9d1898004c84075178bd13abdc97c410" => :el_capitan
  end

  devel do
    url "https://github.com/libgit2/libgit2/archive/v0.27.0-rc2.tar.gz"
    sha256 "7ba5b1155f3a35da63654f29465ab7e39e616a039b05bd639e38194e9c2784be"
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
