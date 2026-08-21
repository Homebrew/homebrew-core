class Libgit2AT18 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.org/"
  url "https://github.com/libgit2/libgit2/archive/refs/tags/v1.8.7.tar.gz"
  sha256 "a548a2209c3e99d6bb685d843396fff3a7d3ffd8340adb5d8851637cfe8cd134"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }

  livecheck do
    url :stable
    regex(/^v?(1\.8(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "10b9b8c3b0bd97cb012e4b09d0c1dac22c8236e5560c322464f6ad23d6d0f8fd"
    sha256 cellar: :any, arm64_sequoia: "45367241a76e1c75dc8f3fc86fa3177bcecb82f0627d8f57b6a9f2af49a8dac8"
    sha256 cellar: :any, arm64_sonoma:  "9ae96e903ab3174f17610069bea61e36a9614df539c26b6904115399e95a4abb"
    sha256 cellar: :any, tahoe:         "da7612d6702a0522e9097b68b5ec9a6a03c1b66ee1d01c311eb7594949ca294d"
    sha256 cellar: :any, sequoia:       "5604a6498178ee244b9495c0e076b6990df7b970eb69f200a2d8e10d37f9d3b9"
    sha256 cellar: :any, sonoma:        "52fef04de666b87d2de175c51ceb86eb574d5a7bda1ca02ba5209a22d8e64c3d"
    sha256 cellar: :any, arm64_linux:   "756286facc17cf443fce8508ff29a275daf7d18c9c43c096615ea64f449095f0"
    sha256 cellar: :any, x86_64_linux:  "45be31330c5bc5ba85a3a2a5c98481bfe1e0d6fdcf600fff0a3150b86b5232ea"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libssh2"

  on_linux do
    depends_on "openssl@3" # Uses SecureTransport on macOS.
    depends_on "zlib-ng-compat"
  end

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
