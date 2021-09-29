class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v1.3.0.tar.gz"
  sha256 "192eeff84596ff09efb6b01835a066f2df7cd7985e0991c79595688e6b36444e"
  license "GPL-2.0-only"
  head "https://github.com/libgit2/libgit2.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "38bc082cccfd0260b0319aa536ae394d1ff42410c70a78d2a57d1924cb5c12c1"
    sha256 cellar: :any,                 big_sur:       "3c75789859b0f68b4e2c966cfed99b165ee7782e8cdbdd2399fd9f62b2f87358"
    sha256 cellar: :any,                 catalina:      "6306bc528ea3213ddcbf58b67c3aab853df9e080a2b52fe579d28d522426ab61"
    sha256 cellar: :any,                 mojave:        "4579e5a13904dd0e5b5d974e6add2520d0412900358f8f898a24a91d87c09748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8db15f41f7c7ff78053a4f7fe3e2556ccffa8efc2da08cc1eeea961e973466f0"
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
        (pkgshare/"examples").install "lg2"
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
