class Advancemame < Formula
  desc "MAME with advanced video support"
  homepage "http://www.advancemame.it/"
  url "https://github.com/amadvance/advancemame/releases/download/v3.6/advancemame-3.6.tar.gz"
  sha256 "6759dd524bfdf071ceb95a56df87464693a3c62df7cc3127acc7e83f9f4606cf"

  bottle do
    sha256 "68814ac2f24c61b03e395f0b39141b8d1a32a39f193c25a8a1e21000bdae7556" => :high_sierra
    sha256 "2a64703b056e341dd6ee4773038f5d4fa289ae120e64b852d103c41cffec3fee" => :sierra
    sha256 "1f67883e185c7d2afe1bfef2ab7eac425c15c4540d648cabb40b2cde8aba0e7f" => :el_capitan
    sha256 "1865a05529d60f846bb97b29c936aaf49f975d788d3687a7b7e87fcd0681bf3d" => :yosemite
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
