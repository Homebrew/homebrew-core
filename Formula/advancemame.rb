class Advancemame < Formula
  desc "MAME with advanced video support"
  homepage "https://www.advancemame.it/"
  url "https://github.com/amadvance/advancemame/releases/download/v3.9/advancemame-3.9.tar.gz"
  sha256 "3e4628e1577e70a1dbe104f17b1b746745b8eda80837f53fbf7b091c88be8c2b"

  bottle do
    sha256 "7c0d8622e79774fe6d3e5fb419e7b16667884059b96bec29d43233d4bff94dff" => :mojave
    sha256 "6874ef4519e20fd5aad80571a73092a183ba23eae319f0079251f6b7039a7f41" => :high_sierra
    sha256 "d5ebe4757331c258d9d0366aa3f382ebb2dad5efcfb4e2e2de70e99eaf8e7e04" => :sierra
    sha256 "b4bd5176614953e8e385f7ceaac8fc27d5f23843a510a822d9f062b49df5a2eb" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "sdl"

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
