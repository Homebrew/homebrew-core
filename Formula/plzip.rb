class Plzip < Formula
  desc "Data compressor"
  homepage "http://www.nongnu.org/lzip/plzip.html"
  url "https://download.savannah.gnu.org/releases/lzip/plzip/plzip-1.5.tar.lz"
  sha256 "0e2e8644b0ec2c4319d0fab470eeb1bc41f36bdd612882beec332149a7aa564b"

  bottle do
    cellar :any_skip_relocation
    sha256 "8bb211a7a090509a64c331dcdca1bbcd201bc7e1b6a8bcf59cde64637be5d053" => :sierra
    sha256 "0da26f741281bcf54cd0ae9d443b867bdde9dde340bf83fcabc6c0f22c887016" => :el_capitan
    sha256 "fe05c1a91ccf2cd262041facaed4fade1ea45b957eabb127070333d79efed3eb" => :yosemite
    sha256 "3e7f98cc5a785d008c7fa9a9dac0b641240ca268089964730705601744e7ff38" => :mavericks
  end

  depends_on "lzlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    text = "Hello Homebrew!"
    compressed = pipe_output("#{bin}/plzip -c", text)
    assert_equal text, pipe_output("#{bin}/plzip -d", compressed)
  end
end
