class Bdftopcf < Formula
  desc "Convert X font from Bitmap Distribution Format to Portable Compiled Format"
  homepage "https://gitlab.freedesktop.org/xorg/util/bdftopcf"
  url "https://www.x.org/archive/individual/app/bdftopcf-1.1.tar.bz2"
  sha256 "4b4df05fc53f1e98993638d6f7e178d95b31745c4568cee407e167491fd311a2"
  license "MIT-open-group"

  depends_on "pkg-config" => :build
  depends_on "xorgproto"  => :build

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.bdf").write <<~EOS
      STARTFONT 2.1
      FONT -gnu-unifont-medium-r-normal--16-160-75-75-c-80-iso10646-1
      SIZE 16 75 75
      FONTBOUNDINGBOX 16 16 0 -2
      STARTPROPERTIES 2
      FONT_ASCENT 14
      FONT_DESCENT 2
      ENDPROPERTIES
      CHARS 1
      STARTCHAR U+0041
      ENCODING 65
      SWIDTH 500 0
      DWIDTH 8 0
      BBX 8 16 0 -2
      BITMAP
      00
      00
      00
      00
      18
      24
      24
      42
      42
      7E
      42
      42
      42
      42
      00
      00
      ENDCHAR
      ENDFONT
    EOS

    system bin/"bdftopcf", "./test.bdf", "-o", "test.pcf"
    assert_predicate testpath/"test.pcf", :exist?
  end
end
