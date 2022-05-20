class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v1.4.3.tar.gz"
  sha256 "f48b961e463a9e4e7e7e58b21a0fb5a9b2a1d24d9ba4d15870a0c9b8ad965163"
  license "GPL-2.0-only"
  head "https://github.com/libgit2/libgit2.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ac2e4d650923dae8c0b505c1da893ac8796f31eea90ce4a18dc27973b5fe57db"
    sha256 cellar: :any,                 arm64_big_sur:  "685749c2c44e8f3c49fe21c9b563d1675e624d338fcca57a6800eae1b9a32e0d"
    sha256 cellar: :any,                 monterey:       "8052e8ecea8a1b1339592ac2ff1cf632aa5b2c54671d228eb2099cad38a3ddd0"
    sha256 cellar: :any,                 big_sur:        "1cdff7e9f77e4b152e4e4bfddc78aad0a873f86675e565db67b39588cc1d2fd6"
    sha256 cellar: :any,                 catalina:       "ee378ffca2d6420949ba67ddfd10deb3b829de2c551364b88d4d6561fd3df7ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0b3b89733c750a24c93cc47ef3d74d36e59ffc604d7932610d3b16d5825b934"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libssh2"

  def install
    args = std_cmake_args
    args << "-DBUILD_EXAMPLES=YES"
    args << "-DBUILD_CLAR=NO" # Don't build tests.
    args << "-DUSE_SSH=YES"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      cd "examples" do
        (pkgshare/"examples").install "lg2"
      end
      system "make", "clean"
      system "cmake", "..", "-DBUILD_SHARED_LIBS=OFF", *args
      system "make"
      lib.install "libgit2.a"
    end
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
