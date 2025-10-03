class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.org/"
  url "https://github.com/libgit2/libgit2/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "14cab3014b2b7ad75970ff4548e83615f74d719afe00aa479b4a889c1e13fc00"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/libgit2.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "92ba96326fe44da38d4cc45571d8641d5c2518888cea9c69caa440b54ea5bf77"
    sha256 cellar: :any,                 arm64_sequoia: "3be60ae5bc7e68b788b021eaf00927f595c28bfed352cd5bf8c212494392dfb8"
    sha256 cellar: :any,                 arm64_sonoma:  "31dddaeed7d870255b55862bf1458ea442e726c72fcd516517b93f002a6e4eec"
    sha256 cellar: :any,                 arm64_ventura: "73166df03c2abe26516e8dc29a5b3dfaf8131a519a724520efeb817cb6936dc7"
    sha256 cellar: :any,                 sonoma:        "e78dcb0d653757bf490171d0f06ef2d2a9cd84adcf06289ae2291abb7af98de3"
    sha256 cellar: :any,                 ventura:       "fe95873314027a33370d727981ff4e1691f263d456ce2c984f60ce1205d5640c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fb6d073915fe93cb06dbb1c24bb27ea65286c776b8983b0fd9e4325f0b0e4d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5ac108401839f186c11126f3a0d9127a1ce3b17999de29a1c3a502070a84f65"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libssh2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3" # Uses SecureTransport on macOS
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
