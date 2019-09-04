class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.2.2.tar.gz"
  sha256 "83b333940a25fe6d453bcac6ea39edfa244612a879117c4a624c97eb250246fb"
  revision 1

  bottle do
    sha256 "97578f2f42dcfc6a342f9915c5507c68ac39c88869654d54764699ec382d3f61" => :mojave
    sha256 "286620a821fb1622ae155bf6db7d220f5ecf047cf6c1b8dc765823112ea48ede" => :high_sierra
    sha256 "fb57aba87e2e2627bdcf309c2a129cb2ef64bf2c45e493ecc5f286cc8a16fc98" => :sierra
  end

  depends_on "libevent"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--with-libevent=#{Formula["libevent"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/nsd", "-v"
  end
end
