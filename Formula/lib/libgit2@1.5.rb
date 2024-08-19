class Libgit2AT15 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "57638ac0e319078f56a7e17570be754515e5b1276d3750904b4214c92e8fa196"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4064a3e2a44b267384af9b2e5e6476ca7928f609a700cdde11cedb84bb99ce78"
    sha256 cellar: :any,                 arm64_ventura:  "273499a81de78a836ebd135415c4d2690139cd189968ee2409d29368a8df3f7e"
    sha256 cellar: :any,                 arm64_monterey: "1b1be422a6954f83139d2ce56752566ce0f9253805cc0c94dea7f6ea44aff6bc"
    sha256 cellar: :any,                 arm64_big_sur:  "b3431dfca6fa375a8d3fbeb07ec300e6ca8b41e2f1ea210ec9c8ccbbab061557"
    sha256 cellar: :any,                 sonoma:         "53e09fc08386bda623d0af2f1999855c25e05fec6ca823f4cc5d01358e43a664"
    sha256 cellar: :any,                 ventura:        "2ced030755f22a160210405875a5b5c692000841b951dd00d9983df0528a323d"
    sha256 cellar: :any,                 monterey:       "d4d841933fb2a8e5432065f2fcae5832b22ae7944c2ae1c382a14b07f7a39b0a"
    sha256 cellar: :any,                 big_sur:        "bbff0c4ba567505eb2a6fc7fa1a4408102de58741da23ed31a569ad04819daf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d96943d843a16680363dd9ac2efef7db0f0187221d1b6a8b613ab7be71184d89"
  end

  keg_only :versioned_formula

  disable! date: "2024-04-01", because: :unmaintained

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libssh2"
  depends_on "openssl@3"

  def install
    args = %w[-DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF -DUSE_SSH=ON -DBUILD_SHARED_LIBS=ON]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
