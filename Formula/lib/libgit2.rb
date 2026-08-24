class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.org/"
  url "https://github.com/libgit2/libgit2/archive/refs/tags/v1.9.7.tar.gz"
  sha256 "1a4fbe7589e814777ae76b64734ad80f4ecad22cd33a22682a2aaea4ae5375e7"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  compatibility_version 1
  head "https://github.com/libgit2/libgit2.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "68a1ad4fce40bdf9e0c260255673ad0922fa907e6694640fadd13390175b2ba7"
    sha256 cellar: :any, arm64_sequoia: "1d74b1ac7a97adda0eeb9e09d04d7d22d5116b2896b5a5c38d0224c3c7c38f3b"
    sha256 cellar: :any, arm64_sonoma:  "73d1d2a42ec12c9358061812f8b76ec60133f576ed6a1deb7eec6702965d1eb0"
    sha256 cellar: :any, sonoma:        "eaa45bc1e600e79f5b281797af48eca04f0e29114dd418207361a6baf0543133"
    sha256 cellar: :any, arm64_linux:   "8ab19827f62d97d23ad6d2c6e0b12b4f11aa1b35824935cca3990e9aedf4523f"
    sha256 cellar: :any, x86_64_linux:  "0c13eaf7a228f13657080aa1e7f7e25318ab7e53c193e577e19fe5a62a2f1e77"
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
