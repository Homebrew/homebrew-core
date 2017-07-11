class Libuninameslist < Formula
  desc "Library of Unicode names and annotation data"
  homepage "https://github.com/fontforge/libuninameslist"
  url "https://github.com/fontforge/libuninameslist/releases/download/20170701/libuninameslist-dist-20170701.tar.gz"
  sha256 "649e3be72cfa9512a48a8c862400168a8972fee72f9a5ee48ad1d1a3e41b08e7"

  bottle do
    cellar :any
    sha256 "89f42b1f93e0b965c1930df437ee21f1f2ec6fafa436bf3b32514c34599f6499" => :sierra
    sha256 "7cd4a7eb9516d4091c2c0414c4d9e943838e58ec08020077529972ff31c99b7d" => :el_capitan
    sha256 "fee8fcc04608fee46357c229e5774046359d86640a50cbe4cef6200d861c6eed" => :yosemite
  end

  head do
    url "https://github.com/fontforge/libuninameslist.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
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
    (testpath/"test.c").write <<-EOS.undent
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
