class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.13.1.tar.gz"
  sha256 "d3cdeff52914a82c4d815e4570f6aab0e14586754377b5d2b9cffdcbcb1ccc29"

  bottle do
    cellar :any
    sha256 "75e4e23993c4a0051b8f02133c825cfc7874db10fd4780161ff2413fc2b2153a" => :mojave
    sha256 "8116479eacfc5e7d9d463a98b0bbef1eca4f89b878a9ffd8ef37a02b149f68f8" => :high_sierra
    sha256 "234f0ac36ece60e82c0fd808df4aba614222c231db5181014e8a4e694456809c" => :sierra
    sha256 "2e691d6a0a7f5bf18c69d6eb624af3e4c7166b4197ce9918c02d6a12686316e3" => :el_capitan
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
