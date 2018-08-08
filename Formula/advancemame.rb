class Advancemame < Formula
  desc "MAME with advanced video support"
  homepage "https://www.advancemame.it/"
  url "https://github.com/amadvance/advancemame/releases/download/v3.8/advancemame-3.8.tar.gz"
  sha256 "f0a5d20f8d512e3bf54078c85fcab209718c172cf7d795391edaa29612e96015"

  bottle do
    sha256 "6874ef4519e20fd5aad80571a73092a183ba23eae319f0079251f6b7039a7f41" => :high_sierra
    sha256 "d5ebe4757331c258d9d0366aa3f382ebb2dad5efcfb4e2e2de70e99eaf8e7e04" => :sierra
    sha256 "b4bd5176614953e8e385f7ceaac8fc27d5f23843a510a822d9f062b49df5a2eb" => :el_capitan
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
