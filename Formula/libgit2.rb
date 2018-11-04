class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v0.27.7.tar.gz"
  sha256 "1a5435a483759b1cd96feb12b11abb5231b0688016db506ce5947178f6ba2531"
  head "https://github.com/libgit2/libgit2.git"

  bottle do
    cellar :any
    sha256 "640ab236291c600299d1a59545fa4087d5f29672d2687d7e797755e69058edc8" => :mojave
    sha256 "3ec4d61485eb4e46976aaed7fd1d2cd7f842f8b2c649c870ec3a2ba79517fdd0" => :high_sierra
    sha256 "9946b33af89f683497ba8a2ac7b992b12d25792ae6b28b6995282c748bfb4c79" => :sierra
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
