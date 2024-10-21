class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "184699f0d9773f96eeeb5cb245ba2304400f5b74671f313240410f594c566a28"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/libgit2.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9284d0ff64158a23a702818a8c4822755f6da3344445b65769fdce4b3721e6ad"
    sha256 cellar: :any,                 arm64_sonoma:  "0f7b8801042541d71967c11a49f1d323b2b0b3ac466f41417b53e1ef525e0c3f"
    sha256 cellar: :any,                 arm64_ventura: "ad3ea8e1f3180d5701e4ba977d7f27d3909b3fba6e6907b7f135e0afb4da2e12"
    sha256 cellar: :any,                 sonoma:        "9ff3b55ea7ec27dfda365ce710d3d21fcfe0bef952521e6901e268c5258f3bbe"
    sha256 cellar: :any,                 ventura:       "efdcd3317260809b700d7edf47d117ebd5f3e024664ba8e8646b4764d850b585"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db478f04a5cdc7196b5988fe99e95292d6038edd289531b9ff96fa181e23f642"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libssh2"
  depends_on "openssl@3"

  def install
    args = %w[-DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF -DUSE_SSH=ON]

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "build-static", "-DBUILD_SHARED_LIBS=OFF", *args, *std_cmake_args
    system "cmake", "--build", "build-static"
    lib.install "build-static/libgit2.a"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <git2.h>
      #include <assert.h>

      int main(int argc, char *argv[]) {
        int options = git_libgit2_features();
        assert(options & GIT_FEATURE_SSH);
        return 0;
      }
    EOS
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
