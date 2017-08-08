class Libuninameslist < Formula
  desc "Library of Unicode names and annotation data"
  homepage "https://github.com/fontforge/libuninameslist"
  url "https://github.com/fontforge/libuninameslist/releases/download/20170807/libuninameslist-dist-20170807.tar.gz"
  sha256 "0afa78c09468738fe92b83bdfda3f1b4b773a57e67f676f6a5203e64de0d1aa4"

  bottle do
    cellar :any
    sha256 "7acb853a3dfee07369af31362838b5197f3209ecbf8615bde22bbd101be23bc8" => :sierra
    sha256 "4e6851ee1829cfddda282d2b818af28995555955db064f5cc5a90dabdde50ba7" => :el_capitan
    sha256 "d23db374f7e2b07ac1996f461fcf900b48bfdfc79abd70e60f77f60a9ac0df49" => :yosemite
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
