class Libmikmod < Formula
  desc "Portable sound library"
  homepage "https://mikmod.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mikmod/libmikmod/3.3.11.1/libmikmod-3.3.11.1.tar.gz"
  sha256 "ad9d64dfc8f83684876419ea7cd4ff4a41d8bcd8c23ef37ecb3a200a16b46d19"

  bottle do
    cellar :any
    sha256 "c69fe0dbab9fb93187e1388d4e388c00c73930dfb3bdd668a0a60228cd8d681b" => :mojave
    sha256 "062f1a9e2c4d5ebc6cfb08e70abbdf4ebd85b06519345ed8bde301e62d0cd860" => :high_sierra
    sha256 "f7785b9a4f95ff28d55ffd022780ed1cd9bde139b3482cc4f52b862cd9abf247" => :sierra
    sha256 "202b59906b8113d694f9c1e81df7a5f00f8afbc9e66a2b1188674058a64ae206" => :el_capitan
    sha256 "8276808d976d108dd2768cacb5b54bf570ef6662b8855e7d3537e0ffaaeb1a19" => :yosemite
  end

  def install
    mkdir "macbuild" do
      # macOS has CoreAudio, but ALSA, SAM9407 and ULTRA are not supported
      system "../configure", "--prefix=#{prefix}", "--disable-alsa",
                             "--disable-sam9407", "--disable-ultra"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/libmikmod-config", "--version"
  end
end
