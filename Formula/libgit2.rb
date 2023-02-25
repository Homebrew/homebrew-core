class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v1.6.2.tar.gz"
  sha256 "d557fbf35557bb5df53cbf38ae0081edb4a36494ec0d19741fa673e509245f8f"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/libgit2.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8b38c1a0bf3ea37fa8c9c4ae08fa2d88adfc1be486c10bc58e1ff194281c703b"
    sha256 cellar: :any,                 arm64_monterey: "99d59aff461775cd6af4d771e9cf1a35631d0ab80e87848474dd9005da5325fc"
    sha256 cellar: :any,                 arm64_big_sur:  "295f4a95636a2c67dc88124c676afac753a43a24780b7fa7d7d453b38a7150c8"
    sha256 cellar: :any,                 ventura:        "7623ae483c5e375a19c3728fe12d2ff53c6a138ddf7151956a4a6ec67c58f92e"
    sha256 cellar: :any,                 monterey:       "3da6ef728dbc67482868f24f6023b78aec73cb9d350cf7043ee0e57772f7d28f"
    sha256 cellar: :any,                 big_sur:        "0820189ba200513d3855a9c49ea9236edfeb7e285f63fda267f8387da32c20b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "016e41900dd2630bd8573c00a2fd4e268d0c9064e772c53588d45bcc7e2557b6"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libssh2"

  # TODO: Remove ASAP after merge.
  conflicts_with "pygit2", because: "pygit2 inadvertently links with unversioned `libgit2` while building"

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
