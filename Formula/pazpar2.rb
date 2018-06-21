class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.13.0.tar.gz"
  sha256 "06adfbb0e215ae37bdbf7ddc173ba619359213c893d059e7a2203e91ac877f45"
  revision 4

  bottle do
    cellar :any
    sha256 "e33724b4d63916aca0c3cac89e517e15b67ee0e3630af3cd460d39507949f0df" => :high_sierra
    sha256 "f45fe2c1eb88ee197322f058e3b17f25e4b8538bec79eb91c90a41da563e07fb" => :sierra
    sha256 "17fd021e2103853590c081d33ee166f3bfac899d720e2c5c5227d1b688e01b15" => :el_capitan
  end

  head do
    url "https://github.com/indexdata/pazpar2.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c" => :recommended
  depends_on "yaz"

  def install
    system "./buildconf.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test-config.xml").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <pazpar2 xmlns="http://www.indexdata.com/pazpar2/1.0">
        <threads number="2"/>
        <server>
          <listen port="8004"/>
        </server>
      </pazpar2>
    EOS

    system "#{sbin}/pazpar2", "-t", "-f", "#{testpath}/test-config.xml"
  end
end
