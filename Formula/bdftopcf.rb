class Bdftopcf < Formula
  desc "Convert X font from Bitmap Distribution Format to Portable Compiled Format"
  homepage "https://gitlab.freedesktop.org/xorg/util/bdftopcf"
  url "https://www.x.org/archive/individual/app/bdftopcf-1.1.tar.bz2"
  sha256 "4b4df05fc53f1e98993638d6f7e178d95b31745c4568cee407e167491fd311a2"
  license "MIT-open-group"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c383fdd1ab5a895939a59cbbc84c5269cc4237030ce62f51fd8cb56884bf78e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96b1cad7bbf70e54ecf15c419f721b4844af29f8dfa346167dd4fd765402d411"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "402d436d944450817e8e8f86491c544739cea6377e994fd69a8d25eb05fea076"
    sha256 cellar: :any_skip_relocation, ventura:        "fbd303098b55994e4d01063d13c0245bc0c4246ba8d5db235e759509fcf870bf"
    sha256 cellar: :any_skip_relocation, monterey:       "58dec51b6b84908ca02b8f62939079bacc1a2fdba84e1d15c41afcbe51a12b0f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a3f6991ea766faf9a04c289b4be77eb41ed3821819328375184738f5629afa0"
    sha256 cellar: :any_skip_relocation, catalina:       "d48cfa639a005786a4bed6f517729c932d80fa53d8a12b3e5c4301f7fa3506a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5808e28509b2ec50be770771e154baa70566113d961428403cbbe0392b4adc9f"
  end

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
