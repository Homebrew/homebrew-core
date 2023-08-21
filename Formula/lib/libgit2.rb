class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v1.6.4.tar.gz"
  sha256 "d25866a4ee275a64f65be2d9a663680a5cf1ed87b7ee4c534997562c828e500d"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  revision 1
  head "https://github.com/libgit2/libgit2.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2397abb72e01e08acec420aa55b787459fbf678ffdd13d4d9f4728eda818f800"
    sha256 cellar: :any,                 arm64_monterey: "ac8d4365e5934eefa014be623fa5a93f52b5106221f1a71f8ed31ce36ad18cd6"
    sha256 cellar: :any,                 arm64_big_sur:  "0e835df6e63b9368ecf71f757df0bc71f87e6488b833757136f4bbe98a74ca5f"
    sha256 cellar: :any,                 ventura:        "d0942b923c027438c776298fe388e595d8bbf87daf3db1aa82e2927ffef2785d"
    sha256 cellar: :any,                 monterey:       "d9a5acf3df857605f5dd7814760062a0bca3f5877eb67786c5f6d3e8a8081c26"
    sha256 cellar: :any,                 big_sur:        "5e897e058041e1c9b947883c750911f90727f851545d8dd92c2e20eac3d34cf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f6702df8184a73fed8ea3568ece9d96bc3bc1a8faef13c457bbf1be5f014210"
  end

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
