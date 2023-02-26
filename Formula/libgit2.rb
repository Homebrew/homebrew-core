class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v1.5.2.tar.gz"
  sha256 "57638ac0e319078f56a7e17570be754515e5b1276d3750904b4214c92e8fa196"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/libgit2.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "878a27344ff72b2e2f2272e469d6c59d79fe1b94d4b2a7ef094f96a79d1586e1"
    sha256 cellar: :any,                 arm64_monterey: "4bdd0868e63dada2dcb110cacba98c1a504e55916a7ede7aa7784b79d08b377c"
    sha256 cellar: :any,                 arm64_big_sur:  "5a42ec263b9b6e3444703d65409ce6138e97e07e8f800cad827d558070616a8a"
    sha256 cellar: :any,                 ventura:        "5ac8892784485d13f7da1e4e0e8af43955fbdde7fdbbd347aa86f682fb5de206"
    sha256 cellar: :any,                 monterey:       "fc0bbb5bc882bfbf760719bd64ae458bdccb6da1f4870e87bf9673e8c92c8490"
    sha256 cellar: :any,                 big_sur:        "411a47793cc2b833ee59e218ce730117ba56eae52b110912e679e3edef1472f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef1307c7dc45522a9aa79a409e5553f1ccd68b18d05e8a41b02af8ac0a124f39"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libssh2"

  def install
    args = std_cmake_args
    args << "-DBUILD_EXAMPLES=YES"
    args << "-DBUILD_TESTS=OFF" # Don't build tests.
    args << "-DUSE_SSH=YES"

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
      #include <assert.h>

      int main(int argc, char *argv[]) {
        int options = git_libgit2_features();
        assert(options & GIT_FEATURE_SSH);
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
