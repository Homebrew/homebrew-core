class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v0.27.5.tar.gz"
  sha256 "15f2775f4f325951d9139ed906502b6c71fee6787cada9b045f5994072ccbd33"
  head "https://github.com/libgit2/libgit2.git"

  bottle do
    cellar :any
    sha256 "8669d420d0fd404a381601bea44e80b5987c24c657b03540e2dca897cedb04d4" => :mojave
    sha256 "19b5bdc78b9020da2a149301d52db2b65d3fa906ef423c84e0f2eafd7321c21c" => :high_sierra
    sha256 "b6b6492e018c515482ed97e23c75d1abc2b3a5ab47e7e39be9c4de04b1842046" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl" if MacOS.version <= :lion # Uses SecureTransport on >10.7
  depends_on "libssh2" => :recommended

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
