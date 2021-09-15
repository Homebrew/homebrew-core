class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v1.1.1.tar.gz"
  sha256 "13a525373f64c711a00a058514d890d1512080265f98e0935ab279393f21a620"
  license "GPL-2.0-only"
  head "https://github.com/libgit2/libgit2.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "71ddae10a8e81012cdfb6877791ffeefef8421efcc7077e61d995aca5cc85275"
    sha256 cellar: :any,                 big_sur:       "86c3794bf3890b7cbe622a1838517a93c4ee380682dae5da9f24c24d9256c094"
    sha256 cellar: :any,                 catalina:      "9284d9a772c9bc29b52a0eef78f5c4f8a5f1ad659eb4024c53ebe6286a50facd"
    sha256 cellar: :any,                 mojave:        "f8c6f89c82c013531e7355d79643dff7c7bf658bedaa9ff3fdfa44ee440b2abe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06a55904d78e73ea93567d825fbca98102abb496cfcbeb05bfc1a464672bdf53"
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
