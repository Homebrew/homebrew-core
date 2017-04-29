class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.1.16.tar.gz"
  sha256 "7f8367ad23cc5cddffa885e7e2f549123c8b4123db9726df41d99f255d6baab2"

  bottle do
    sha256 "a151c4ee34b03883204024d75a8764110f60b27ecd16833565a462dd518aefef" => :sierra
    sha256 "a88214c56bcecdca5c9e661eb3a98aa72369ecea4d65cfe0729572261d1a2c19" => :el_capitan
    sha256 "e735828b0cb4220ae7ead4d6d612844ac9901da5f4d1943debdfb53cfeb32144" => :yosemite
  end

  option "with-root-server", "Allow NSD to run as a root name server"
  option "with-bind8-stats", "Enable BIND8-like NSTATS & XSTATS"
  option "with-ratelimit", "Enable rate limiting"
  option "with-zone-stats", "Enable per-zone statistics"

  depends_on "libevent"
  depends_on "openssl"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-ssl=#{Formula["openssl"].opt_prefix}
    ]

    args << "--enable-root-server" if build.with? "root-server"
    args << "--enable-bind8-stats" if build.with? "bind8-stats"
    args << "--enable-ratelimit" if build.with? "ratelimit"
    args << "--enable-zone-stats" if build.with? "zone-stats"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{sbin}/nsd", "-v"
  end
end
