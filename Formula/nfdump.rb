class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command-line"
  homepage "https://nfdump.sourceforge.io"
  url "https://github.com/phaag/nfdump/archive/v1.6.20.tar.gz"
  sha256 "672f4fbe2b7424cfdba5917441100a440cbc9083f2a79147562fb5a966838543"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "c83ba9aaa48563952986ff836401cf32eb218025b976f0b16400db4ca4e191c4" => :catalina
    sha256 "2d8e2b2f2515b141dd79bc26994320a2e2d1aae7927f7a62d8183afae07f7689" => :mojave
    sha256 "75ca1d3a74970fa228e2d5ef5c54e39e9f9b9b434e90220fdf8c41ba5bed9c3c" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--enable-readpcap"
    system "make", "install"
  end

  test do
    system bin/"nfdump", "-Z", "host 8.8.8.8"
  end
end
