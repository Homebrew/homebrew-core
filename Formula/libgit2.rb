class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v0.26.0.tar.gz"
  sha256 "6a62393e0ceb37d02fe0d5707713f504e7acac9006ef33da1e88960bd78b6eac"
  head "https://github.com/libgit2/libgit2.git"

  bottle do
    sha256 "2858f330bff072c20375d4882042123022e81237f0f3ca8382c9e3a017f514d6" => :high_sierra
    sha256 "1cb3dac0dfc74a62e40e061c3046ce938b8c28fe0fea15e398cc4862178aa940" => :sierra
    sha256 "8705a0cc5f73017412ce12fd87677e9b6e14781d82b6f845a64ffe84e24ecb2f" => :el_capitan
    sha256 "f44d62f41114ee8ecba3298986cf9da5cf4b6cb44a64a9a64dd0c316938712d1" => :yosemite
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
