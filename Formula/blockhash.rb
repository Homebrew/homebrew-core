class Blockhash < Formula
  desc "Perceptual image hash calculation tool"
  homepage "http://blockhash.io/"
  url "https://github.com/commonsmachinery/blockhash/archive/0.2.tar.gz"
  sha256 "485c356afc665ab26a33dfe2d6e67feb3dfc3ca610f7ea80bd28b121c42640ca"
  head "https://github.com/commonsmachinery/blockhash.git"

  bottle do
    cellar :any
    sha256 "4b59f164df5c6338d17f42fad75aef4691255d029847bfaa9dff284a4ea28613" => :sierra
    sha256 "a0f883806ac4e7372a2c55bbe25c7a0c957c9143b73c6a727e3404fc05acaa78" => :el_capitan
    sha256 "4b32b379f7173508f6d2bb35bacc87da86d92f552532727a56d30b129c263575" => :yosemite
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
    hash = "00007ff07fe07fe07fe67ff07520600077fe601e7f5e000079fd40410001fffe"
    result = shell_output("#{bin}/blockhash #{testpath}/clipper_ship.jpg")
    assert_match hash, result
  end
end
