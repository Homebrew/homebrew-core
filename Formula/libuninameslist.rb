class Libuninameslist < Formula
  desc "Library of Unicode names and annotation data"
  homepage "https://github.com/fontforge/libuninameslist"
  url "https://github.com/fontforge/libuninameslist/releases/download/20211114/libuninameslist-dist-20211114.tar.gz"
  sha256 "f5f69090de4a483721207a9df7de5327c13c812a1d23de074d8f0496bc2b740d"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)*)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "52a867309170da4f022177dedcacd778d93822952333408ee7e9df1e32e9ab34"
    sha256 cellar: :any,                 arm64_big_sur:  "08d9a0329d057e4dc9cc1211a70409b2816241b093500c2ed2712320bbe162da"
    sha256 cellar: :any,                 monterey:       "d4ce52bf3926b9cf5f1c1bfec702706ea7516744f8d76706cb0880fb1c272127"
    sha256 cellar: :any,                 big_sur:        "12309abb98a5e23b712d583cced9d25a2f0b0aabd7499cb6a561458440c36576"
    sha256 cellar: :any,                 catalina:       "f9eb6d104a3b0e20751b6dc3ffc8c63552ae46a367135b48ca3191280e7c0787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "135de398275c32165030df5b3af15e49172e498fda65271f85facf396e4df527"
  end

  head do
    url "https://github.com/fontforge/libuninameslist.git"

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
