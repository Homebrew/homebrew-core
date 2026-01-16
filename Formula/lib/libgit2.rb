class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.org/"
  url "https://github.com/libgit2/libgit2/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "6f097c82fc06ece4f40539fb17e9d41baf1a5a2fc26b1b8562d21b89bc355fe6"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/libgit2.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0487941c2bb7a4cc5e9fb6889ce5b59df5170aee82b09ed7f98c4b6e37605198"
    sha256 cellar: :any,                 arm64_sequoia: "33a644b00bee978d555bb24da7d14dca74493bc61a990005f2a2d8d481881910"
    sha256 cellar: :any,                 arm64_sonoma:  "a567eb4f4e74fda3737e2356dcddfbdf7c4f0d394752dcfbaafe6755ec87cbd4"
    sha256 cellar: :any,                 sonoma:        "3f5efa13871bdf61b377f4b8f90be2a620d256a1e70c7cba8f6c20425766b65c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91d4925f6697e563e404f6f53b8f9cc0f1e8889d1947deae0fc84be748236b4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0761d0b8b02213dee40ec29560c152c3de1703c8f10e4c2f73847ff113480d98"
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
