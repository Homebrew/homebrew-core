class Psftools < Formula
  desc "Tools for fixed-width bitmap fonts"
  homepage "https://www.seasip.info/Unix/PSF/"
  # psftools-1.1.10.tar.gz (dated 2017) was a typo of 1.0.10 and has since been deleted.
  # You may still find it on some mirrors but it should not be used.
  url "https://www.seasip.info/Unix/PSF/psftools-1.0.13.tar.gz"
  sha256 "9c61e6885dca2f9591b4aa5fe821e16d4779cd071c3a45ead326629f210def65"
  version_scheme 1

  bottle do
    cellar :any
    sha256 "30d2a62f05343fbd172a0b7d094e84755d3441fae6e9a5734793cf363a9e8c40" => :catalina
    sha256 "9a04003b9ff3529c3e1e94f63b062c120b8a5e4af66a99965347d63827004128" => :mojave
    sha256 "cd1682c76f401ff6fc6c4dce3e4c5d31aeb50a2deb4b56a31b8bab5830c6ec4b" => :high_sierra
  end

  depends_on "autoconf" => :build

  resource "pc8x8font" do
    url "https://www.zone38.net/font/pc8x8.zip"
    sha256 "13a17d57276e9ef5d9617b2d97aa0246cec9b2d4716e31b77d0708d54e5b978f"
  end

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    # The zip file has a fon in it, use fon2fnts to extrat to fnt
    resource("pc8x8font").stage do
      system "#{bin}/fon2fnts", "pc8x8.fon"
      assert_predicate Pathname.pwd/"PC8X8_9.fnt", :exist?
    end
  end
end
