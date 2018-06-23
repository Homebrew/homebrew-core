class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.13.0.tar.gz"
  sha256 "06adfbb0e215ae37bdbf7ddc173ba619359213c893d059e7a2203e91ac877f45"
  revision 4

  bottle do
    cellar :any
    sha256 "a757c82fe5cb1b6e0b2e42608d0222d99899bc9dde01ddd29af687c6cc7e97a1" => :high_sierra
    sha256 "83a327732668b5e2fbdb05c7a8341edd53d607594cf1ca23db7ab187114e2c18" => :sierra
    sha256 "d9af4c53fb66ba2ea5b0fc438772561a56a599becb3882c0dcd205928bfc32d7" => :el_capitan
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
