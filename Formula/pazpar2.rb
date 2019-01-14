class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.13.1.tar.gz"
  sha256 "d3cdeff52914a82c4d815e4570f6aab0e14586754377b5d2b9cffdcbcb1ccc29"
  revision 1

  bottle do
    cellar :any
    sha256 "53937090561ad043932b1da6d141ea769396cc6bb4f5cdd49a2a20ecce39d436" => :mojave
    sha256 "9ba978deab4a3910cfd7382711d582151c9aa190b7f27a6c005f1ed35358c73d" => :high_sierra
    sha256 "8cd5847dd58310b8883e5a60b08c5da0b098f64fa2ca2e46aed24aad3129277c" => :sierra
  end

  head do
    url "https://github.com/indexdata/pazpar2.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c"
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
