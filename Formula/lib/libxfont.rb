class Libxfont < Formula
  desc "X.Org: Core of the legacy X11 font system"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXfont-1.5.4.tar.bz2"
  sha256 "1a7f7490774c87f2052d146d1e0e64518d32e6848184a18654e8d0bb57883242"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "ee220e54e315af68b0bd094585389b09266cb8b7916e834d51704d8f957079ab"
    sha256 cellar: :any,                 arm64_sequoia:  "7274a6c0a84b2d5a62c3c7cbaeeb39467f6cd133c9f1e549d3d343cf6d413e97"
    sha256 cellar: :any,                 arm64_sonoma:   "fa76bdfe924cef05ae6293065ec87537cda1d850116b8d8a9b97ed33e5c7b2ca"
    sha256 cellar: :any,                 arm64_ventura:  "e85ca79059256c31175a8b3ed1b04268f6bf81a05e52df6699f53f6b4d88fdc6"
    sha256 cellar: :any,                 arm64_monterey: "7ca1ffead34e1adfcd19864bd1edd9d54c67cebf9f96bb5901b63e850ffcfc95"
    sha256 cellar: :any,                 arm64_big_sur:  "6751afe1988e433646ee650ecc0cf508db5ac90fe9f3760114a8960e7467e13e"
    sha256 cellar: :any,                 sonoma:         "300eb427bc067d4072b00734d8168604b36b9a07c9e01af60135bc2301018883"
    sha256 cellar: :any,                 ventura:        "a4545c69641b0c902efc13cdbb96bda838b07e773aadf1537575be224203996a"
    sha256 cellar: :any,                 monterey:       "41dd4b2590dcffafe77d8816501406fcfeeb9236ec278f2ba702c28fa4d3d4de"
    sha256 cellar: :any,                 big_sur:        "816829490c6b978eaaa6b068ef42e89f1196be5d186d5c407b670f49dfa7f66b"
    sha256 cellar: :any,                 catalina:       "0321fea5b7329575b6d4b3ed762d741309c329c74df6a9ae2693667828e9a1da"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "cd90ca9f06f262584a557fb3109a3090f12a6786de1ca899b08a6fd99ea7de45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2c2202c343f1c42b642eaa9e4410f3886faf1158fd7a271ad928623922a43ee"
  end

  depends_on "pkgconf" => :build
  depends_on "util-macros" => :build
  depends_on "xtrans" => :build
  depends_on "freetype"
  depends_on "libfontenc"
  depends_on "xorgproto"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-silent-rules
      --enable-devel-docs=no
      --with-freetype-config=#{Formula["freetype"].opt_bin}/freetype-config
      --with-bzip2
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "X11/fonts/fntfilst.h"
      #include "X11/fonts/bitmap.h"

      int main(int argc, char* argv[]) {
        BitmapExtraRec rec;
        return 0;
      }
    C
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
