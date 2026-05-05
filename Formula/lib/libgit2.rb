class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.org/"
  url "https://github.com/libgit2/libgit2/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "6f097c82fc06ece4f40539fb17e9d41baf1a5a2fc26b1b8562d21b89bc355fe6"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  revision 3
  compatibility_version 1
  head "https://github.com/libgit2/libgit2.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "53c58d492ddab149c2cc76b2cba6717935cff08348dcb250762e5ecc94793099"
    sha256 cellar: :any,                 arm64_sequoia: "3a612eb2cf9a5f6f872baffa1b43643969ee4ba8901dfe070ff1ea7baf6b204c"
    sha256 cellar: :any,                 arm64_sonoma:  "fbb917ea9623578572bf97f36e86a57a7a0983c0069d167bef40224f4e98795c"
    sha256 cellar: :any,                 sonoma:        "df45947e30998e47ae6c547dbb9550b63a2a822e542d6221f6c6681ea6eaf7c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbe8631b467e0add62e8e4e3261b9410b6f0939946f92b31ff86f6596fa66051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fec5a8fac2d572a4ef28949f760046054dbe82f71a2c610e91cf62da7de1d02d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libssh2"
  depends_on "llhttp"

  on_linux do
    depends_on "openssl@4" # Uses SecureTransport on macOS
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
