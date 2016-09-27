class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.1.13.tar.gz"
  sha256 "c45cd4ba2101a027e133b2be44db9378e27602e05f09a5ef25019e1ae45291af"

  bottle do
    rebuild 1
    sha256 "86f39990c7c37eb468c8097f5b521ec3efec2df26981ca14e182fdc4f5108565" => :sierra
    sha256 "cd71e6b0744d7c621fc661a4b90508d8ae7183525ddec132514f0056a4851a6d" => :el_capitan
    sha256 "aa19b165478511defe721c85ae3776650593e08e17338f17ebeea35ad824ce33" => :yosemite
    sha256 "06fac55fa2c9e80a821a5ef047889e6bf080701a8f6e4cdb459e4f34a7fa24c1" => :mavericks
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
