class Libgit2 < Formula
  desc "C library of Git core methods that is re-entrant and linkable"
  homepage "https://libgit2.github.com/"
  url "https://github.com/libgit2/libgit2/archive/v1.4.2.tar.gz"
  sha256 "901c2b4492976b86477569502a41c31b274b69adc177149c02099ea88404ef19"
  license "GPL-2.0-only"
  head "https://github.com/libgit2/libgit2.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "51be10e4f4fcb27e158df8c3d08089fd80487b535c7ddbf7fd579079d0d266aa"
    sha256 cellar: :any,                 arm64_big_sur:  "36e3dab47fb868251f9d6c5031555bf5b3d4ca77f9297ba3a3c6059073a8639f"
    sha256 cellar: :any,                 monterey:       "cb79f47251bd93fa1928cc67dcad8d6743824a261294267dca805d21f529ad89"
    sha256 cellar: :any,                 big_sur:        "fb8a865d86ebaab7ef467f0a6d7d5d92a1ace4bebb6c178f2d6ca8eebd733a87"
    sha256 cellar: :any,                 catalina:       "6cae593b02835e7b448e2a86db8fcafa9783858f0ef3201be0c4ffe8853852cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa6392e44db9c1ecd169f534c0a97a3a278cead366c63ec3a1aac09d4bfa1d41"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libssh2"

  def install
    args = std_cmake_args
    args << "-DBUILD_EXAMPLES=YES"
    args << "-DBUILD_CLAR=NO" # Don't build tests.

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

      int main(int argc, char *argv[]) {
        int options = git_libgit2_features();
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
