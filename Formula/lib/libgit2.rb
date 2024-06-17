class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "de384e29d7efc9330c6cdb126ebf88342b5025d920dcb7c645defad85195ea7f"
  license "GPL-2.0-only" => { with: "GCC-exception-2.0" }
  head "https://github.com/libgit2/libgit2.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "20b0ffc207c455904322e9b34ab8bb0754673009f903f3e2e5e72624e5c8d434"
    sha256 cellar: :any,                 arm64_ventura:  "24db489f9dcc45a3f1a263f70ee0e32c9b26b9c06f96b51675a9efd7d4209c64"
    sha256 cellar: :any,                 arm64_monterey: "fd851c4e62f9dae0209603f7686845f75af89b33b0b4ac630aa2fe551893de5a"
    sha256 cellar: :any,                 sonoma:         "fa795ec23fd0a86652caae32a1a17680622acc63834c1c24d05139a14e0fdddd"
    sha256 cellar: :any,                 ventura:        "cc0879a3c2ebd7422fa38185eef484baf7664df5351f5d2bd789cf939c9f0b9c"
    sha256 cellar: :any,                 monterey:       "15c37eed6c0493caad3dca7b9a92e56766bd942641e592aee2d1c684e4400660"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bffadb3a3c52c63d77d66f4aa530d500c978436a858e4d88b2602bed8030017f"
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
