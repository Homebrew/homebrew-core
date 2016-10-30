class Docbook2x < Formula
  desc "Convert DocBook to UNIX manpages and GNU TeXinfo"
  homepage "http://docbook2x.sourceforge.net/"
  url "https://downloads.sourceforge.net/docbook2x/docbook2X-0.8.8.tar.gz"
  sha256 "4077757d367a9d1b1427e8d5dfc3c49d993e90deabc6df23d05cfe9cd2fcdc45"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1110d4bd90cecf9ce8edacc27a3edc84dfcd4db7ab50b67269af0eb6a9bb00a" => :sierra
    sha256 "acfdd1c80cb523b213dea0125819b1b6fc783d6d740cc8fc0047f44756b57889" => :el_capitan
    sha256 "e3efe4afe190e126174c6e3bec0a9feb4ad37ddd0ecaef778b1e8df8a60e8717" => :yosemite
    sha256 "4b4750b139d7a262735e33ee0e314c7a589b6ada2d72e336aabaf334789a411d" => :mavericks
  end

  depends_on "docbook"

  def install
    inreplace "perl/db2x_xsltproc.pl", "http://docbook2x.sf.net/latest/xslt", "#{share}/docbook2X/xslt"
    inreplace "configure", "${prefix}", prefix
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
