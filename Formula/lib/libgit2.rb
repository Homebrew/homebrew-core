class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "75b27d4d6df44bd34e2f70663cfd998f5ec41e680e1e593238bbe517a84c7ed2"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/libgit2.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f0ee705c27e87553582c58556a2a20a766af1e1ffbef0f1c676b0244e89398b9"
    sha256 cellar: :any,                 arm64_sonoma:  "74a27239cf67c5e87b45b9cf3db547a41ace91b9fab9dbd44608bf1dc3faf3df"
    sha256 cellar: :any,                 arm64_ventura: "ff62b8ec0e1a2b212eff271c39bbd801c45b4bba3595b3f361b7d90f5b3d11b3"
    sha256 cellar: :any,                 sonoma:        "fb233893f22e55ca0cd7856f5ec319d077530ad1a5341c3c067d53ce2135627d"
    sha256 cellar: :any,                 ventura:       "f5eb731a1908b229c0f7da31345af99a176c51f813069401884aada234c1247c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79a4e1ecc35d78bf1f3dde86c43b13b16db902e74ad97d06f2d4f8f2fe2c5d88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be9b0548c38c23f5ef5cecb22db883a65324ef385610f944e4506af6cf077aad"
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
