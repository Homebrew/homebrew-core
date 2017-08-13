class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.12.9.tar.gz"
  sha256 "86142e1275546e95395a0b82bfc6d4e5b24b86183ec1a59f843033c1cbdd815d"
  revision 1

  bottle do
    cellar :any
    sha256 "0e7d29ac2c9b732b1c44b9bd1d6175d521cb6e879e4b2f9b01fe8bae8472f4a3" => :sierra
    sha256 "1f7ae6f0a6a2a1b0dac05b9b0fc0ddd3dab9516da20af578e033d882e892c1e3" => :el_capitan
    sha256 "b3eedb42b874dc3d18e1726e59d28d4643de51d50ea6e6d2487abfd0b934ed88" => :yosemite
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
    (testpath/"test-config.xml").write <<-EOS.undent
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
