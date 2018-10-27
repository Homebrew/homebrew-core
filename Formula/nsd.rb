class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.1.25.tar.gz"
  sha256 "8f5bff5abbbb03c396afd7be575806cde1217e884c189fa34445e0ca4793df7f"

  bottle do
    sha256 "79b060790201a13210c2233559f6148e8697f902729a11445de906d877fe3993" => :mojave
    sha256 "8fd4fa8c342da1c793f2ec752d142aea3a3a597c7846d5ea1708c90824376e71" => :high_sierra
    sha256 "3abbf3549bc204ae1520c371214666384d1810edec41bacfcfdca8e11287b124" => :sierra
  end

  depends_on "libevent"
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--with-libevent=#{Formula["libevent"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/nsd", "-v"
  end
end
