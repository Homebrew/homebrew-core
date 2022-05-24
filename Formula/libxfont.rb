class Libxfont < Formula
  desc "X.Org: Core of the legacy X11 font system"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXfont-1.5.4.tar.bz2"
  sha256 "1a7f7490774c87f2052d146d1e0e64518d32e6848184a18654e8d0bb57883242"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7ca1ffead34e1adfcd19864bd1edd9d54c67cebf9f96bb5901b63e850ffcfc95"
    sha256 cellar: :any,                 arm64_big_sur:  "6751afe1988e433646ee650ecc0cf508db5ac90fe9f3760114a8960e7467e13e"
    sha256 cellar: :any,                 monterey:       "41dd4b2590dcffafe77d8816501406fcfeeb9236ec278f2ba702c28fa4d3d4de"
    sha256 cellar: :any,                 big_sur:        "816829490c6b978eaaa6b068ef42e89f1196be5d186d5c407b670f49dfa7f66b"
    sha256 cellar: :any,                 catalina:       "0321fea5b7329575b6d4b3ed762d741309c329c74df6a9ae2693667828e9a1da"
    sha256 cellar: :any,                 mojave:         "68cfb860815eedac8d96bb1853a64a12c3cc77bcc0e99ffbd693666b2bfb9119"
    sha256 cellar: :any,                 high_sierra:    "54fe9ff4143205d5d14a416f276193c4f9f5dc83898a057823462ac78c8de891"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2c2202c343f1c42b642eaa9e4410f3886faf1158fd7a271ad928623922a43ee"
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
