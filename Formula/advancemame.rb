class Advancemame < Formula
  desc "MAME with advanced video support"
  homepage "http://www.advancemame.it/"
  url "https://github.com/amadvance/advancemame/releases/download/v3.4/advancemame-3.4.tar.gz"
  sha256 "54fe7444534d47f99243dc78c4b2de8e878575f59978d149bf69f3d1c0332edb"

  bottle do
    sha256 "06a81121a865472d2c8272d3b2aab3c3a9696a8147f0482065fe0cce71935a9f" => :sierra
    sha256 "d960b6791b36de466156a487696b497365d1c48142e9787d70490349fc848923" => :el_capitan
    sha256 "047441f3ea40e24029b36452bb7eff8867a86ac5ffe4899b04d6fc006d7c27c2" => :yosemite
  end

  depends_on "sdl"
  depends_on "freetype"

  conflicts_with "advancemenu", :because => "both install `advmenu` binaries"

  def install
    ENV.delete "SDKROOT" if MacOS.version == :yosemite
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "LDFLAGS=#{ENV.ldflags}", "mandir=#{man}", "docdir=#{doc}"
  end

  test do
    system "#{bin}/advmame", "--version"
  end
end
