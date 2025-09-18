class Libgit2AT18 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "49d0fc50ab931816f6bfc1ac68f8d74b760450eebdb5374e803ee36550f26774"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }

  livecheck do
    url :stable
    regex(/^v?(1\.8(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ca8afa1e5028bd4eeaf13f844319531ee98f0df24f8ae3b4be006e212d6c8cc9"
    sha256 cellar: :any,                 arm64_sequoia: "5a9fe4aae3865e5c977633107b829e639e6535d8f986c851d60d63bb2e5b0932"
    sha256 cellar: :any,                 arm64_sonoma:  "d04a13a2da8d14c6f0bee82751d472b13aa0fd8ed688eff218f7a0a18d29bf59"
    sha256 cellar: :any,                 arm64_ventura: "94ef273252c464c308e859ebfb3b78814516f6a740d40c57394805c4fbcbcb58"
    sha256 cellar: :any,                 sonoma:        "4848894348322217f276122ab1d3307778f473430abbc51dc22818273b06cf83"
    sha256 cellar: :any,                 ventura:       "9a389072e0da2cb33c2c82bf7d57c49844c92c82be47d19f7e25f0b6666aa8c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4d124965d0952c612e40c46a4fe3423220509d57cc61118fe15eecce3dbc2ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "105c2c951f86f9de73797b314f92b46bddab6b6bb779cee7303d9eebec8a1c18"
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
