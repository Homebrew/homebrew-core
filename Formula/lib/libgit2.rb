class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.org/"
  url "https://github.com/libgit2/libgit2/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "6f097c82fc06ece4f40539fb17e9d41baf1a5a2fc26b1b8562d21b89bc355fe6"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  revision 1
  head "https://github.com/libgit2/libgit2.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "97ff2e84ab73e8cb56e5884cf26c27ea4e4bb21987549c0706816b0bc45532a9"
    sha256 cellar: :any,                 arm64_sequoia: "c2694695e86b097811b664c9e0382f217c4b4300cf32cc0c62f28fe172ed3536"
    sha256 cellar: :any,                 arm64_sonoma:  "8ae9df99ad28aff8e5aee4400c2ff2124d2ec01f6480a730a71767b46cac6a3b"
    sha256 cellar: :any,                 sonoma:        "af08d60e1020689f58c37f7d9a2e465353fdca50c0b33ee353e1512a0f2827dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42e7be69909a93ad884898883441819318fd6cbb0df1b58a683ee97c69b4b900"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a8609a42095a81ca3061e76d9605bd160e395d66a588a5757f676e2bc8417a6"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libssh2"

  on_linux do
    depends_on "openssl@3" # Uses SecureTransport on macOS
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
