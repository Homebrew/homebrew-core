class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v1.4.2.tar.gz"
  sha256 "901c2b4492976b86477569502a41c31b274b69adc177149c02099ea88404ef19"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/libgit2/libgit2.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ba844640bf55e048c7c1000619e88656f2bc5f39411003b95ab923301917a14e"
    sha256 cellar: :any,                 arm64_big_sur:  "64995a946f855eef27fd0ceb184693b3c5774f4ba875673d999ab54bc778a4fe"
    sha256 cellar: :any,                 monterey:       "d9197798c559cdb6e7c360e4b85f6e8f22c2a07462928dd3b7f56be2aa8cd61c"
    sha256 cellar: :any,                 big_sur:        "17d55226d035b43a2f5248d026b35c7850090475b60300abe539ba4bcff67a1f"
    sha256 cellar: :any,                 catalina:       "4f9e56622c47612bff8c681bb5714fdb478f1b5abc2123486daaf72a29bff807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96136c8fc93c4f9d86c813c86b11d12e84249588ca85aca61d3390c51432f9a6"
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
