class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.org/"
  url "https://github.com/libgit2/libgit2/archive/refs/tags/v1.9.4.tar.gz"
  sha256 "824b73bd13647800fe4b566a1008ae77fea0e3e3424edab632fcfd8c0b14ba8b"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  compatibility_version 1
  head "https://github.com/libgit2/libgit2.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bf2ddbba78112618223f7569b64d3010503bd54c8947dacd9efaa04ff9db44eb"
    sha256 cellar: :any,                 arm64_sequoia: "4634e55aff52f5c486c937139015b225303b979b601a1647c94d8b417e7a2995"
    sha256 cellar: :any,                 arm64_sonoma:  "5e24788310bdecf3b379f693351da33e82d72374d4a8f5cdda437cd7ccce5c4c"
    sha256 cellar: :any,                 sonoma:        "d63056ead2ea3a27579342ab9d82995ccc2cd9fa41aa19018dd64acca1a70b66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9666b81b35e53d8f00279d85c0367c5eef81a93b0f476af31b976cc2d4e3473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72a6dd759b679d08f67e7a55defe01056256de8740416d7348b9f85e00928b12"
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
