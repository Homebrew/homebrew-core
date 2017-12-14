class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.13.0.tar.gz"
  sha256 "06adfbb0e215ae37bdbf7ddc173ba619359213c893d059e7a2203e91ac877f45"
  revision 2

  bottle do
    cellar :any
    sha256 "5f47a4a9a43b0f0cb809d5aa970d22ea5563f0cfa0e19a97cda9b9f1234e7a42" => :high_sierra
    sha256 "49dcc40ada66b7df235dcc48945f5c7c876cd04795bf8bbd9ea677f5252c2249" => :sierra
    sha256 "689295e23f755c1e91b54a944abca9235e090ae9a4b2e5bed479cd95de89ba20" => :el_capitan
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
