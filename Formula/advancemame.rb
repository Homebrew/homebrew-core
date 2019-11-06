class Advancemame < Formula
  desc "MAME with advanced video support"
  homepage "https://www.advancemame.it/"
  url "https://github.com/amadvance/advancemame/releases/download/v3.9/advancemame-3.9.tar.gz"
  sha256 "3e4628e1577e70a1dbe104f17b1b746745b8eda80837f53fbf7b091c88be8c2b"

  bottle do
    sha256 "7530ca2e37ac45b53164ae54ab6669f1796ea0af88541a85a93a74c155fb0029" => :catalina
    sha256 "95f2cdff91ff98c3c9f65a0751d7948cefb3829d96e1977b5b8869163eba0790" => :mojave
    sha256 "9c5e0a9f81f43ec02eb951b82b4930639dafcdbacbeadf7bcc5e74f2e2ec7c45" => :high_sierra
    sha256 "6ba2c02db07a9ef7ddf561dbc2cde3904abe0b1b0ab9c9469020fdeced72e011" => :sierra
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
