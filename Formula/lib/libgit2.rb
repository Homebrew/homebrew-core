class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.org/"
  url "https://github.com/libgit2/libgit2/archive/refs/tags/v1.9.6.tar.gz"
  sha256 "a88a42a4ea9bdab7aa8686eead3bf7d9c6dd74529caca16ab22eaa92433d31d9"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  compatibility_version 1
  head "https://github.com/libgit2/libgit2.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "514d04cc09891594fcf526891f25e13aa36763742c452c4f66a4f1b02252e59a"
    sha256 cellar: :any, arm64_sequoia: "c03026c6f2d44f346976c3fcb468312fa48d37668c95aba095644e606f82eb90"
    sha256 cellar: :any, arm64_sonoma:  "6b3e9f6c99bf2b3b241189cb94343b886e888826bfcf5d3e95aa8a01f98ac6e1"
    sha256 cellar: :any, sonoma:        "af0de12098395a96729742220019d0e505e862f6cbb9118fcd1ffe789df673b2"
    sha256 cellar: :any, arm64_linux:   "9d76512f605981e9d9e7fd6cdd817c13e44e4955786c5960ca59f572e0de15ba"
    sha256 cellar: :any, x86_64_linux:  "190580065f7e95bafdb657415d226749ceef5d07508323454cd6d7035c7733c2"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libssh2"
  depends_on "llhttp"

  on_linux do
    depends_on "openssl@3" # Uses SecureTransport on macOS
    depends_on "pcre2" # Uses regcomp_l on macOS which needs xlocale.h
    depends_on "zlib-ng-compat"
  end

  def install
    # Remove bundled libraries
    rm_r(Dir["deps/*"] - ["deps/ntlmclient", "deps/xdiff"])

    args = %w[
      -DBUILD_EXAMPLES=OFF
      -DBUILD_TESTS=OFF
      -DUSE_BUNDLED_ZLIB=OFF
      -DUSE_HTTP_PARSER=llhttp
      -DUSE_SSH=ON
    ]
    # TODO: Switch to USE_REGEX in 1.10
    args << "-DREGEX_BACKEND=pcre2" if OS.linux?

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
