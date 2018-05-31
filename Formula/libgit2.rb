class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v0.27.1.tar.gz"
  sha256 "837b11927bc5f64e7f9ab0376f57cfe3ca5aa52ffd2007ac41184b21124fb086"
  head "https://github.com/libgit2/libgit2.git"

  bottle do
    sha256 "c5872104089a92994d3e44589122d5f60a577667cc2a44ccf0cc84b81dea22d8" => :high_sierra
    sha256 "29ddd87a24d97f8e97ed21cdf470ea78e36a63a0737d145611618b7a0f9cc288" => :sierra
    sha256 "9fddafd7f742c5c602e62a694ddfec5235a7faa7ca3eb16f5bc62dc590ed70f7" => :el_capitan
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
