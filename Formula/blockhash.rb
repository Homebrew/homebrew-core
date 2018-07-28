class Blockhash < Formula
  desc "Perceptual image hash calculation tool"
  homepage "https://github.com/commonsmachinery/blockhash"
  url "https://github.com/commonsmachinery/blockhash/archive/v0.3.1.tar.gz"
  sha256 "56e8d2fecf2c7658c9f8b32bfb2d29fdd0d0535ddb3082e44b45a5da705aca86"
  head "https://github.com/commonsmachinery/blockhash.git"

  bottle do
    cellar :any
    sha256 "ba87b5b649164c63d82f1693588414d994e0f2837c6f6f169634c9fc94d812f6" => :high_sierra
    sha256 "7cd8bc3a26ce19bb2b5b36e92679fef23bc751b6773752169f29eae595242f6b" => :sierra
    sha256 "e02dd7c2cf8fe76de1f376c1001c22b8b1a614897b4ffa77d89b648953b07c25" => :el_capitan
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
