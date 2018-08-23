class Blockhash < Formula
  desc "Perceptual image hash calculation tool"
  homepage "https://github.com/commonsmachinery/blockhash"
  url "https://github.com/commonsmachinery/blockhash/archive/v0.3.1.tar.gz"
  sha256 "56e8d2fecf2c7658c9f8b32bfb2d29fdd0d0535ddb3082e44b45a5da705aca86"
  head "https://github.com/commonsmachinery/blockhash.git"

  bottle do
    cellar :any
    sha256 "6ffdc13e9245f06147a95870dbf8b0b380bda2cb4fb0036988cf1d9f4a96ce2c" => :mojave
    sha256 "c4b04968387672dded5493575dbc182f9a8cd43dce80943c5eaca9450cee1a44" => :high_sierra
    sha256 "e684a55045cca7db8816b9fdb0881290c5cf80c20230dab454aef1d90f45adf4" => :sierra
    sha256 "aadd5917fdb402fad8d6b7b02ca379cdefec0151edf0b8fa1135ccf1767e610f" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "imagemagick"

  resource "testdata" do
    url "https://raw.githubusercontent.com/commonsmachinery/blockhash/ce08b465b658c4e886d49ec33361cee767f86db6/testdata/clipper_ship.jpg"
    sha256 "a9f6858876adadc83c8551b664632a9cf669c2aea4fec0c09d81171cc3b8a97f"
  end

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end

  test do
    resource("testdata").stage testpath
    hash = "00007ff07ff07fe07fe67ff07560600077fe701e7f5e000079fd40410001ffff"
    result = shell_output("#{bin}/blockhash #{testpath}/clipper_ship.jpg")
    assert_match hash, result
  end
end
