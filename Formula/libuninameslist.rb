class Libuninameslist < Formula
  desc "Library of Unicode names and annotation data"
  homepage "https://github.com/fontforge/libuninameslist"
  url "https://github.com/fontforge/libuninameslist/releases/download/20160701/libuninameslist-20160701.tar.gz"
  sha256 "1981701b4b44455a9cc5ab203172014137ec5b77e3ebc3cbf79294c8a26ee6f6"

  bottle do
    cellar :any
    sha256 "abe252a972b156dc8187e0ab89cdcb49c274bf6d79f4c3552b50f37f7b54eb31" => :sierra
    sha256 "d5cacf981764a6d5ea93f0ae4ecbc05ca406b3226b53065d7dcecdfa1c2abdc0" => :el_capitan
    sha256 "160cc64ecac03e2243b5c8943f7b67380d6595c84c7e4bd8d3d748abb6a6aa25" => :yosemite
    sha256 "008830e4f830024cd9725a004963ca3d8bb87134cab7281b29d836988f981ba9" => :mavericks
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
