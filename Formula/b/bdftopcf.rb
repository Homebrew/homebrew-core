class Bdftopcf < Formula
  desc "Convert X font from Bitmap Distribution Format to Portable Compiled Format"
  homepage "https://gitlab.freedesktop.org/xorg/util/bdftopcf"
  url "https://www.x.org/releases/individual/util/bdftopcf-1.1.2.tar.xz"
  sha256 "bc60be5904330faaa3ddd2aed7874bee2f29e4387c245d6787552f067eb0523a"
  license "MIT-open-group"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c5cce829845d0c176e814c40a20e018c9d04a9fe01774bba881526ec0c85023b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ece11c5aa3b020507c597dcedfefe2b513903cdf4577147115a4cd77d39b0277"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd210923efefbe66ac49de78a8151dec06b63b76453afb1458105cf10130b6f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a157c335ea904af1890eadf062b01e28ade46d1eaf27ed16a573d9db36267e00"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee45ef9fa4bfcafde669505ffb448fb380af04ea4ece11c6e59b7b4a8148e3d7"
    sha256 cellar: :any_skip_relocation, ventura:       "cb5d73a38109e5b4519d9db189f7d251dd1a93e6e71421fcf1a1c320dd9ba808"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9504712a8df5ab24fffa7944c6b5d6a698fc97463e133ca71a8da88d57c1587e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d558ac21dd07f613ee4ebea998439f027b861a788fde3095a7d59193ea33562c"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

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
    assert_path_exists testpath/"test.pcf"
  end
end
