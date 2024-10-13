class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "8c1eaf0cf07cba0e9021920bfba9502140220786ed5d8a8ec6c7ad9174522f8e"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/libgit2.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "9ce2ed6059b2af3f57e06ffbca33419328406e406ed9c9d6913ea04b80c8454d"
    sha256 cellar: :any,                 arm64_sonoma:   "c74a306a3d2a68d22dd3951ca1a2fb0c566fccd4ff7ac1b40c75fb739cf4359f"
    sha256 cellar: :any,                 arm64_ventura:  "da870e964178facdcfddf478f968122daf1ef8e6ef2cf80e23069191c65ce532"
    sha256 cellar: :any,                 arm64_monterey: "6b51ca0ebc9c17d000e7fd88bccb00d60ef33845ac418b8d1ff6f9093e541c58"
    sha256 cellar: :any,                 sonoma:         "52f39e230581ec9b36b5d9021ca9eaed0c8d2bb49c31c2102b74402b5e7b3937"
    sha256 cellar: :any,                 ventura:        "b81c00e45d323da3331f6a6f3ab4c2ce27e7a35f45c256accbb5f534d059e26d"
    sha256 cellar: :any,                 monterey:       "1e0ba01d5c036ae7991437fafd5695bd1c4f4298b6f873a9de751906ddc50445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66c64820e1f7ce0ec927b8195f2748f4bc11065488c59a33ea053f2b3a8f0eb9"
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
