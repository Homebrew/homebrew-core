class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v0.26.0.tar.gz"
  sha256 "4ac70a2bbdf7a304ad2a9fb2c53ad3c8694be0dbec4f1fce0f3cd0cda14fb3b9"
  head "https://github.com/libgit2/libgit2.git"

  bottle do
    sha256 "d43aa3bea4589796cc3819f79e1c0022be9c763a17b8d2a6d88bd16f8c4d2da7" => :sierra
    sha256 "a2c31c7175e7a36fcf6b08d57259490bc16ffd6190e9ca4ae8da3add44a172d9" => :el_capitan
    sha256 "1c9a4e6b427e80df70d78c9dfdf857b269888a2c8091ddcdcc3ce96e6d0acd8d" => :yosemite
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
    (testpath/"test.c").write <<-EOS.undent
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
