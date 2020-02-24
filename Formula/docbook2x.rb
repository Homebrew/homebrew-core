class Docbook2x < Formula
  desc "Convert DocBook to UNIX manpages and GNU TeXinfo"
  homepage "https://docbook2x.sourceforge.io/"
  url "https://downloads.sourceforge.net/docbook2x/docbook2X-0.8.8.tar.gz"
  sha256 "4077757d367a9d1b1427e8d5dfc3c49d993e90deabc6df23d05cfe9cd2fcdc45"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7562a999301c0879be6f39bd031bb886e68ca56c8aca08b1977eaf1e2927496" => :catalina
    sha256 "2009056af30fb2a08a751e055fbdec14d49b4bc51da34cb63737b22b4b4d7784" => :mojave
    sha256 "81734088203909fc5db96462d14116596058910cd1b7ab67389a7bf93c9bae63" => :high_sierra
    sha256 "a1110d4bd90cecf9ce8edacc27a3edc84dfcd4db7ab50b67269af0eb6a9bb00a" => :sierra
    sha256 "acfdd1c80cb523b213dea0125819b1b6fc783d6d740cc8fc0047f44756b57889" => :el_capitan
    sha256 "e3efe4afe190e126174c6e3bec0a9feb4ad37ddd0ecaef778b1e8df8a60e8717" => :yosemite
    sha256 "4b4750b139d7a262735e33ee0e314c7a589b6ada2d72e336aabaf334789a411d" => :mavericks
  end

  depends_on "docbook"

  uses_from_macos "libxslt"
  uses_from_macos "perl"

  def install
    inreplace "perl/db2x_xsltproc.pl", "http://docbook2x.sf.net/latest/xslt", "#{share}/docbook2X/xslt"
    inreplace "configure", "${prefix}", prefix
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    (testpath/"brew.1.xml").write <<~EOS
      <?xml version="1.0" encoding="ISO-8859-1"?>
      <!DOCTYPE refentry PUBLIC "-//OASIS//DTD DocBook XML V4.4//EN"
                         "http://www.oasis-open.org/docbook/xml/4.4/docbookx.dtd">
      <refentry id='brew1'>
      <refmeta>
        <refentrytitle>brew</refentrytitle>
        <manvolnum>1</manvolnum>
      </refmeta>
      <refnamediv>
        <refname>brew</refname>
        <refpurpose>The missing package manager for macOS</refpurpose>
      </refnamediv>
      </refentry>
    EOS
    system bin/"docbook2man", testpath/"brew.1.xml"
    assert_predicate testpath/"brew.1", :exist?, "Failed to create man page!"
  end
end
