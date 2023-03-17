class Libgit2AT15 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v1.5.2.tar.gz"
  sha256 "57638ac0e319078f56a7e17570be754515e5b1276d3750904b4214c92e8fa196"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/libgit2.git", branch: "maint/v1.5"

  livecheck do
    url :stable
    regex(/v?(1\.5(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "45890efc844a6ccde796efa4756a41375735572b54947ecda8e0858b41a884bf"
    sha256 cellar: :any,                 arm64_monterey: "dc152e1db59734a81563ce8f9f058730b05e314fb4bd727a170f1be828e36cc0"
    sha256 cellar: :any,                 arm64_big_sur:  "84a6669c3b32baca505dee3f5d5fb61aa5b6c702c5ba8230d350fda5acee263a"
    sha256 cellar: :any,                 ventura:        "a3d6857aa3b6ba663c7e943b4d081664af897b65350abb6e30193a5483905f3c"
    sha256 cellar: :any,                 monterey:       "2e8ee4edd3649f680229d3b949ebfc635584c8eaf4ddfe606d4ff34b26122e82"
    sha256 cellar: :any,                 big_sur:        "f317f24b43c63188db7c37a88f5cbc7ed75fa5c3ed83d17b1ac4e593e467e634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d04641c90b730f0515ba0b6b577f57ac145e21fdf968ccfddbc554adc9cc0fa3"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libssh2"

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
