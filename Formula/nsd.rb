class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.1.10.tar.gz"
  sha256 "3a757014046752a0b0b11c1a2e22a36bb796f89f6939147ed3226556b4298727"

  bottle do
    sha256 "27b27978fd94cf80e6d81f5fb4d79fd3c0200a49b701f46bd846ded6e04b4b0c" => :el_capitan
    sha256 "f71f850f63ac67f88b8723fb339aa8c2c1e1f1a27d9344394bfd4860bbd160a9" => :yosemite
    sha256 "dbea8ff1b2ad8c9ee9ae2c8b7bc2e6d199782bba4815b70bc55c6856ba310d06" => :mavericks
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
