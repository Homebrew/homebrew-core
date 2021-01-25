class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v1.1.0.tar.gz"
  sha256 "41a6d5d740fd608674c7db8685685f45535323e73e784062cf000a633d420d1e"
  license "GPL-2.0-only"
  head "https://github.com/libgit2/libgit2.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any
    sha256 "8f441c63c8c7737c0278b0537f095c84f0eacf80ff8231df57b5be92474884c2" => :big_sur
    sha256 "cc3c73fe59d8250e417e5bb0e401095fbb3686576302f0e54c9a97dd0c412ed7" => :arm64_big_sur
    sha256 "55559e477a533a5682da7853f03149000cce14371ed7b0ffc5ceaff285b6348b" => :catalina
    sha256 "0bb2d00f1e5b6133df5792c06fd726ad15a9364e184d05653bde6b6c1d5095ae" => :mojave
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
