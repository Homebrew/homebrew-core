class Libuninameslist < Formula
  desc "Library of Unicode names and annotation data"
  homepage "https://github.com/fontforge/libuninameslist"
  url "https://github.com/fontforge/libuninameslist/releases/download/20200413/libuninameslist-dist-20200413.tar.gz"
  sha256 "5c0283b2e18d101e58b70a026119d66c9d3e749e4537def7799bba0bc8998f62"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "38e3ba23a50f2acdebdf4a6419b8e5d996650f9fd9c4e081eb18c77b57dc08ac" => :catalina
    sha256 "5bbf66b5f23f99f833b95fae6462084c98838e79142e66a0e602ad7a70dc13f6" => :mojave
    sha256 "9e6875ea89497fb8f3c8c4121f9142f7ca23f85a4d2ae8b3845d49db4194cf51" => :high_sierra
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
