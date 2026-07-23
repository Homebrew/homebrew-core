class Libgit2AT18 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.org/"
  url "https://github.com/libgit2/libgit2/archive/refs/tags/v1.8.6.tar.gz"
  sha256 "c171e9c6fcc33455e3df46d422f4e1b3ea7c049a645051664c9cdbdc081208e7"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }

  livecheck do
    url :stable
    regex(/^v?(1\.8(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bf1197372b7ae8a5990723a977b2c2e8669d33438c09ab26954bc3e242679e88"
    sha256 cellar: :any, arm64_sequoia: "9a8ebce334e74f0055efd118efb6ad6096178dbf2c8dd336a6fd90fd586036d6"
    sha256 cellar: :any, arm64_sonoma:  "2e91aaa6138dff39f8d1de66f53371e8953633b6467417c607dbc52ad1339f53"
    sha256 cellar: :any, tahoe:         "6787a6866c36231a3c386bd0934b963561d3b80a13ace643773c215380892897"
    sha256 cellar: :any, sequoia:       "11e730b0e63cb66262151996f411b53ffe421bcec5c496f6714aa3e650d61cd2"
    sha256 cellar: :any, sonoma:        "03e045f5d6f46096beed143339ff0f1ed7fd888f0e94c4127620c51af3ba00f6"
    sha256 cellar: :any, arm64_linux:   "de20c3ba3b34bad59a73358c3c5eff0aeb627828331ababc238e575714a95c92"
    sha256 cellar: :any, x86_64_linux:  "8127b9b960e721fbe764aaac8502b00fd0acffa547ea51d19585554fa77e6c1c"
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
