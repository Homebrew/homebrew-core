class Libgit2AT16 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/refs/tags/v1.6.4.tar.gz"
  sha256 "d25866a4ee275a64f65be2d9a663680a5cf1ed87b7ee4c534997562c828e500d"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/libgit2.git", branch: "maint/v1.6"

  livecheck do
    url :stable
    regex(/v?(1\.6(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d2b76777e0b8bf572537ff560539d6ad082c737851a148d71635ab899dbe6ead"
    sha256 cellar: :any,                 arm64_monterey: "54dccd4b043d3915d6e484a6c7d1c91f7bee5cb817a88e2904518227f21c9224"
    sha256 cellar: :any,                 arm64_big_sur:  "06c83654a4ba91a1c2e1f55e1f57265ca54e8e0cd2c5e69dd1177bde611ea33f"
    sha256 cellar: :any,                 ventura:        "c8b88ce5ff326fcde8456badbeca7cb79ad691616fe2cd3bb72bebf858b3bede"
    sha256 cellar: :any,                 monterey:       "30ed081df2702afb0195df083872d31047281018ffd9673aefc1c1e69aaa520c"
    sha256 cellar: :any,                 big_sur:        "e227aa3abda0ff012daf47518843b49567daa0f23338872ada0253bae5368d30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "faba71e6669662f6e2ce0e49c1c42776735496b844f2aaac61d14626a388152f"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libssh2"
  depends_on "openssl@3"

  def install
    args = %w[-DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF -DUSE_SSH=ON]

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install "build-static/libgit2.a"
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
