class Psftools < Formula
  desc "Tools for fixed-width bitmap fonts"
  homepage "https://www.seasip.info/Unix/PSF/"
  url "https://www.seasip.info/Unix/PSF/psftools-1.1.10.tar.gz"
  sha256 "1bc03214a29c4fc461a7aa11b9a3debde419b1271fa5110273ded961774e2b6f"

  bottle do
    cellar :any
    sha256 "710ec6da54d533e4ccc37c87093408ec5519d67852bda95485c1ac35564e0a07" => :mojave
    sha256 "40c3b6b56dfa842d6a3058d5082bbe16dd3ef0360258279cca98f9da05ec9cd4" => :high_sierra
    sha256 "532260f14b0b77301c7bf6b89ae1cf7f5948f26dc9d27898bb5588cb9cd4f99e" => :sierra
    sha256 "ecfe3cabea7cb93be49b1189394253c09f8614877e76f8d7f59a7c1e05bc0128" => :el_capitan
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
