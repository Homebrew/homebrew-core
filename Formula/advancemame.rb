class Advancemame < Formula
  desc "MAME with advanced video support"
  homepage "https://www.advancemame.it/"
  url "https://github.com/amadvance/advancemame/releases/download/v3.8/advancemame-3.8.tar.gz"
  sha256 "f0a5d20f8d512e3bf54078c85fcab209718c172cf7d795391edaa29612e96015"

  bottle do
    sha256 "cebd9f5bdee213f0994527f63a3c8ad6d78cb43e377bdd19978fa2d9e03acd15" => :high_sierra
    sha256 "3bf6b73863b14621de91fe5908921d322e28e4e26855eae7f5cf3ba15b360c07" => :sierra
    sha256 "e5f14218046ce7f164a270378743aefff119d0fc7c69987bfb78fc8d1105ea7b" => :el_capitan
  end

  depends_on "pkg-config" => :build
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
