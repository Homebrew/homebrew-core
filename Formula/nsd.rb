class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.1.21.tar.gz"
  sha256 "7858b934a07e1582079d7e724b05855380416b7fd68cdaeeca16305bd66bd2bd"

  bottle do
    sha256 "2a56c4ddbffaeda4ea36b7580fb6f49a4dc2723285bebc8b0e824b1a5f76b8d0" => :high_sierra
    sha256 "888fadf45333a15ab8e890f48329d9114cfdf5c495283f498704464016be97e8" => :sierra
    sha256 "314eb13262850eabe0d7a736d09ff2fd6c5b3b72e64abc869646f2c24adab040" => :el_capitan
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
