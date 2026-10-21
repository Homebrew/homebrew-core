class Libgit2AT18 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.org/"
  url "https://github.com/libgit2/libgit2/archive/refs/tags/v1.8.7.tar.gz"
  sha256 "a548a2209c3e99d6bb685d843396fff3a7d3ffd8340adb5d8851637cfe8cd134"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  revision 1

  livecheck do
    url :stable
    regex(/^v?(1\.8(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c3588203cfc8d71c254ab494cf7fdd6037989b622508a4e34afbbf968f9cacb7"
    sha256 cellar: :any, arm64_tahoe:       "f8dd1adefdec38f3e319f473a3d50bd422a306a918dd090d65ed7eef694561eb"
    sha256 cellar: :any, arm64_sequoia:     "25421d777704cf52ae0dce7564c52f2f74c18b98a390f11a40010cd9d467cbaf"
    sha256 cellar: :any, arm64_linux:       "f1d8318e44db8745c0c8a7152722c55638f127bfdaeb550b3c30325cd86a7331"
    sha256 cellar: :any, x86_64_linux:      "e65cb12d6eb06c7a972df3b14da625785546a2f9399cc24e0192b78af9f7e9ad"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libssh2"

  on_linux do
    depends_on "openssl@4" # Uses SecureTransport on macOS.
    depends_on "zlib-ng-compat"
  end

  deny_network_access!
  def install
    args = %w[-DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF -DUSE_SSH=ON -DUSE_BUNDLED_ZLIB=OFF]

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install "build-static/libgit2.a"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <git2.h>
      #include <assert.h>

      int main(int argc, char *argv[]) {
        int options = git_libgit2_features();
        assert(options & GIT_FEATURE_SSH);
        return 0;
      }
    C
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
