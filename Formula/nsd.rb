class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.1.15.tar.gz"
  sha256 "494a862cfcd26a525a4bf06306eb7ab0387b34678ac6d37767507438e3a23a4b"

  bottle do
    sha256 "7fe76b7fc8ce2bdb9fa9d30a29d1b1c6c930da8deb26f0df4ba8d8b9e6b95ee2" => :sierra
    sha256 "a97ff0daff8e153e8bbbc0144798f46ecf0b8aa302758ec436bbf01c4a5736ee" => :el_capitan
    sha256 "e523fd04dba1bd7720b62e3d6f845d19d333a27b8988c3cd006e002f2d49f9d0" => :yosemite
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
