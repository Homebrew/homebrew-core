class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v1.6.4.tar.gz"
  sha256 "d25866a4ee275a64f65be2d9a663680a5cf1ed87b7ee4c534997562c828e500d"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/libgit2.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a4fe32eb5c124ff3de7175ada725fa5f79e6eb565135a68e460e5cc5b8e8c3d1"
    sha256 cellar: :any,                 arm64_monterey: "85b4e126e155ea395e1a9f75bb9beb157739c28255e32ffbeb21a488fcf46fac"
    sha256 cellar: :any,                 arm64_big_sur:  "6783efc1c351b475a3f6a01d17cc1c44dbb5d187fa0b35e0808dfa316937a6d4"
    sha256 cellar: :any,                 ventura:        "feb4cf7c15be1d00fbe832fa759bb7b204d186576ad7b97449f30088411a7554"
    sha256 cellar: :any,                 monterey:       "7527a7793167c87d83564f22acebcdb7b82a0a6dc1d203d978ce21a2186d8541"
    sha256 cellar: :any,                 big_sur:        "8d126f48f163fd729c73dca2309c502f790b81fd0f908de368a0e8d58b02b774"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d66f66487f9ce0597a357f8a099c0578d9954100825761db6720bf8c099a53e9"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libssh2"

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
