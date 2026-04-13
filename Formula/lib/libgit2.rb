class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.org/"
  url "https://github.com/libgit2/libgit2/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "6f097c82fc06ece4f40539fb17e9d41baf1a5a2fc26b1b8562d21b89bc355fe6"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  revision 1
  compatibility_version 1
  head "https://github.com/libgit2/libgit2.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "8a30e6866a9d341a0536d1ee79084d9a38ccefa0070f36defcf7cd7d0c42d968"
    sha256 cellar: :any,                 arm64_sequoia: "67f5becf455b5bd4fdb21207f914abb074fb48f4b58e0c159e70e916d9256356"
    sha256 cellar: :any,                 arm64_sonoma:  "a805127b9a4bbeeb9f27effee5cc459ce5b5672779bffbaee94e7405db03ec73"
    sha256 cellar: :any,                 sonoma:        "005aea9f682b2dfa3a2606fd953c1fe1bc5e2c10b6b3ad1bda12abe1a61a77af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05d6d6c13bf3130e180ddb471799e8b5ec5cea5ac8d08f7cbecc8b34951cad0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef33f5f695d8bbd7e2dd2b6041ed3fb0b018ffb8d547135224dac33653397d13"
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
