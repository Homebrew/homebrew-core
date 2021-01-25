class Libxfont < Formula
  desc "X.Org: Core of the legacy X11 font system"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXfont-1.5.4.tar.bz2"
  sha256 "1a7f7490774c87f2052d146d1e0e64518d32e6848184a18654e8d0bb57883242"
  license "MIT"

  bottle do
    cellar :any
    sha256 "816829490c6b978eaaa6b068ef42e89f1196be5d186d5c407b670f49dfa7f66b" => :big_sur
    sha256 "6751afe1988e433646ee650ecc0cf508db5ac90fe9f3760114a8960e7467e13e" => :arm64_big_sur
    sha256 "0321fea5b7329575b6d4b3ed762d741309c329c74df6a9ae2693667828e9a1da" => :catalina
    sha256 "68cfb860815eedac8d96bb1853a64a12c3cc77bcc0e99ffbd693666b2bfb9119" => :mojave
    sha256 "54fe9ff4143205d5d14a416f276193c4f9f5dc83898a057823462ac78c8de891" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on "xtrans" => :build
  depends_on "freetype"
  depends_on "libfontenc"
  depends_on "xorgproto"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-devel-docs=no
      --with-freetype-config=#{Formula["freetype"].opt_bin}/freetype-config
      --with-bzip2
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/fonts/fntfilst.h"
      #include "X11/fonts/bitmap.h"

      int main(int argc, char* argv[]) {
        BitmapExtraRec rec;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
