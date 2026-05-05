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
    sha256 cellar: :any,                 arm64_tahoe:   "6c1084dcac57f71921963d974a7c8770d6a688234f06b71daad1693d0433fbc6"
    sha256 cellar: :any,                 arm64_sequoia: "86f44dfd669fe9ef3fd7469c06c9720201343443ab16d4a699cce117cd8647ba"
    sha256 cellar: :any,                 arm64_sonoma:  "f0245d6be18504b3d3f4fc910468418438e604e382507490bec0ae22bf73d11d"
    sha256 cellar: :any,                 sonoma:        "cee518a1118db4114dbc450f61428c269fd9143a6ace26ff6dbefe930856d6f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a11437ebfc7f063ee9a250ac83eb2951fd8e88c9f8bc1bccf0090b0cd225501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9dcd35b71f15be94426e83f25169e9bf653b4e3f6ce67d1b63ba48ece9300e9"
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
