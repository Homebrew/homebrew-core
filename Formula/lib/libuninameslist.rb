class Libuninameslist < Formula
  desc "Library of Unicode names and annotation data"
  homepage "https://github.com/fontforge/libuninameslist"
  url "https://github.com/fontforge/libuninameslist/releases/download/20240524/libuninameslist-dist-20240524.tar.gz"
  sha256 "cb69d6b0b1bf896c98cd00497d3078be2d22b896b0dc7cba2bb3d6bc3172dac5"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)*)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a5769622c9abd616d43925028a1f2befb0c40cc670048907969de21043b78215"
    sha256 cellar: :any,                 arm64_ventura:  "cd150e6629cc06df8126243865187f3773fb4037ce2a55980723354808c4e52f"
    sha256 cellar: :any,                 arm64_monterey: "6ab31e9926f7c3fa9aa31be32c133f75739dc38a720a9243e44ff77706f7cc31"
    sha256 cellar: :any,                 sonoma:         "9a784ef1e5493f1aaaf8b36c7d18614149aa1c8bf3a0a4fdbc56cbabd84c710f"
    sha256 cellar: :any,                 ventura:        "512afebcd96bab9fbaa9397b13340354d3bae0d0b5b18f3a7b4a9e113dfc070f"
    sha256 cellar: :any,                 monterey:       "abe9c004ddc687afd52b05265c5d97fdf73c8b87f2a60d0342d8a8f815b16e0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de768c4963b9ccffe8807ec76b85eefb3af341edf24ffff454d58f584e40c0a6"
  end

  head do
    url "https://github.com/fontforge/libuninameslist.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    if build.head?
      system "autoreconf", "-i"
      system "automake"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <uninameslist.h>

      int main() {
        (void)uniNamesList_blockCount();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-luninameslist", "-o", "test"
    system "./test"
  end
end
