class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "17d2b292f21be3892b704dddff29327b3564f96099a1c53b00edc23160c71327"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/libgit2.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d1de8934d2ee512544fa5d941329c516d64b3c3aad437fef7825a18401c70be9"
    sha256 cellar: :any,                 arm64_monterey: "e45bbf04a950adbd0dbb1bde55572ec384cd0c0635653326d88009c04ec46107"
    sha256 cellar: :any,                 arm64_big_sur:  "bfb4012117dc4d21de49cd707ca108b77f873fdcd17452abb344dfe82de1ffc9"
    sha256 cellar: :any,                 ventura:        "fdf652b3f275218544cd2da03d0afe894eb8484f276a80432cd2bcb1c294dc23"
    sha256 cellar: :any,                 monterey:       "a78523160ada0495659001ed56782abaac2659933e48fe8302e1d3ddfceec6ce"
    sha256 cellar: :any,                 big_sur:        "6026fc1aeb900f24d33bf1fbda44a8a3ce2d84dc14511a8e8af8a3ee312a67a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19126e03d88fc4d91b97c11bc090a9a87180e3dbf6d2ad0d721c5cc4410330d7"
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
