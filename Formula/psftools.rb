class Psftools < Formula
  desc "Tools for fixed-width bitmap fonts"
  homepage "http://www.seasip.info/Unix/PSF/index.html"
  url "http://www.seasip.info/Unix/PSF/psftools-1.0.7.tar.gz"
  sha256 "d6f83e76efddaff86d69392656a5623b54e79cfe7aa74b75684ae3fef1093baf"

  bottle do
    cellar :any
    sha256 "0e8f5ac8fd1dab5c23865b886463f71fbd9013803e97bb934dc6905e46f635fc" => :sierra
    sha256 "66a389177a272c5a03ca11f1cb8f32fdac2899117812ad9206fe6744b4b9118d" => :el_capitan
    sha256 "7e51a8f4c5605780528091208dfdb018c4a7ca0e56ff81cb75715b95fb8a9e9b" => :yosemite
    sha256 "eddaf9caf5a4bb2545665c5323821f883e973ee815b87e7286b9a5b7a2fc3c85" => :mavericks
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
      assert File.exist?("PC8X8_9.fnt")
    end
  end
end
