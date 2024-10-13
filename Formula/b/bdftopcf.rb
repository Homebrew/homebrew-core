class Bdftopcf < Formula
  desc "Convert X font from Bitmap Distribution Format to Portable Compiled Format"
  homepage "https://gitlab.freedesktop.org/xorg/util/bdftopcf"
  url "https://www.x.org/releases/individual/util/bdftopcf-1.1.1.tar.xz"
  sha256 "11c953d53c0f3ed349d0198dfb0a40000b5121df7eef09f2615a262892fed908"
  license "MIT-open-group"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "139f30526b3c42e502bd80de766f015a154f1b543935f0b5c8205485b90bc03a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c50937d505d08e9f61fff7856403b39704a350a08fc8ecd60a75f44bf25e2068"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b26742fa879001426b039393e683b586cae8ef449215e736816b7c036ee80f2b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ef52728cea826773128a733b91368ca316f638c0f5762cc46e7564bc4464b09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61fc99226d4aeaa186d4f715e960c4c8610332c3d77492b03be4cdfaa555afdf"
    sha256 cellar: :any_skip_relocation, sonoma:         "723d079c723344aaa0321a11d5e206a281b297b3f4856faafc50885e9ad328ca"
    sha256 cellar: :any_skip_relocation, ventura:        "1349d3903b391dab646542ae8b42b58f4219377d434a8286521765b108d8ab96"
    sha256 cellar: :any_skip_relocation, monterey:       "1dd18fa43ed7c155cd4915befed4370976cc8f09c9c61982eb161037fda82a86"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3b2cad1bd14de2a14ea5fb8b0a340a7d9bc0397a603ea347cd9e891a2045d08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edc465111a6a38d1baf15911312fea996076ec454dde0c62b41728aa032f121b"
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
