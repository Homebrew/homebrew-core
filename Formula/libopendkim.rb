class Libopendkim < Formula
  desc "Implementation of Domain Keys Identified Mail authentication"
  homepage "http://opendkim.org"
  url "https://downloads.sourceforge.net/project/opendkim/opendkim-2.10.3.tar.gz"
  sha256 "43a0ba57bf942095fe159d0748d8933c6b1dd1117caf0273fa9a0003215e681b"
  revision 1

  bottle do
    sha256 "b144ac9d9fe9a2ba8a298001df5beacde4ed6461dbcdda089d462ddf8314c35a" => :mojave
    sha256 "c44483297476334acbfa979c81902b01528fd5c7a429e699764899512e687fbc" => :high_sierra
    sha256 "5d2163990816a1af9420fc096d3579febb819582053faf133424d689ad5e190c" => :sierra
  end

  depends_on "openssl"
  depends_on "unbound"

  def install
    # --disable-filter: not needed for the library build
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-filter",
                          "--with-unbound=#{Formula["unbound"].opt_prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/opendkim-genkey", "--directory=#{testpath}"
    assert_predicate testpath/"default.private", :exist?
    assert_predicate testpath/"default.txt", :exist?
  end
end
