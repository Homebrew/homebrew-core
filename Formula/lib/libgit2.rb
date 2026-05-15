class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.org/"
  url "https://github.com/libgit2/libgit2/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "d532172d7ab24d2a25944e2434212d63ee85f3650e97b5f7579e7f201a78ad64"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  compatibility_version 1
  head "https://github.com/libgit2/libgit2.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8a31d29d71ba3b9d95d95b86a65e8fa3f0b922710445c6db3772a6631107d274"
    sha256 cellar: :any,                 arm64_sequoia: "1928f4183435a7dcd09254519bc42ed6fc5179e4a6262efb2f0c8c945b63c0bf"
    sha256 cellar: :any,                 arm64_sonoma:  "228a5f0e9c2649ffd69495b10411a2cca6cc34223b16aba152ef18b19aab0b9d"
    sha256 cellar: :any,                 sonoma:        "939637b7c88674006e36a661b3d954363679457b7e30083eb1fecfa77b6d96a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0ac16116eb6f7384716292e2ed62df8e799bcd2cd9a68a18bd1fa0de1b6a76a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "931978e8bd9a7c9f04f79bf0456e99943efa2ebce1a0721b64e88d892aac7ef7"
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
