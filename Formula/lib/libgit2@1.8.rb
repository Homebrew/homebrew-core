class Libgit2AT18 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.org/"
  url "https://github.com/libgit2/libgit2/archive/refs/tags/v1.8.5.tar.gz"
  sha256 "ec70049b8af823b21032447f91a2274fd8d91c435ef326a533dff3824e21b27f"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }

  livecheck do
    url :stable
    regex(/^v?(1\.8(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f4711b2ecc2d4f31e2373f68ca5a44d5c2a8c82816a2448ca4b837febe7be36f"
    sha256 cellar: :any,                 arm64_sequoia: "2a489fc6f255668fca18e41cb2b9365cc3db04775ec0c8cf98d8bb1a6a5fa0ae"
    sha256 cellar: :any,                 arm64_sonoma:  "15c1818f5467da3cad8540f204c50c94091093f7159dbe7d0164881754d82b18"
    sha256 cellar: :any,                 sonoma:        "2a8d89b22a17131267c32cea92d0bbc5ea400b8710183a01b67798edcc40a963"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e442c1163128eb80c16749f3fa08286809c6d49b26a7b8e23976cc354804bb91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "638cc940fc5a542fb2bffa0b9b1aa90ce3499bd9437f1ff1c6e141a8819eff12"
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libssh2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3" # Uses SecureTransport on macOS.
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
