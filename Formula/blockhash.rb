class Blockhash < Formula
  desc "Perceptual image hash calculation tool"
  homepage "https://github.com/commonsmachinery/blockhash"
  url "https://github.com/commonsmachinery/blockhash/archive/v0.3.tar.gz"
  sha256 "a4fbe16dc8d1e9b82de860d97222ce6259495f7832c7dfe3de9e0bb42f85995e"
  revision 1
  head "https://github.com/commonsmachinery/blockhash.git"

  bottle do
    cellar :any
    sha256 "2c1bd0b349770ebb96d240bb284bb35bad9d0e218290771fe18e1ec0ea9ad881" => :high_sierra
    sha256 "6b7be5048231ce278951d52458d4c38a8cdfdd496843bf231d971fe69c0b2811" => :sierra
    sha256 "52e4284db0b8bffeed973cd2c0bceb52fb6174256425a4fe689f2eba64a5b079" => :el_capitan
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
