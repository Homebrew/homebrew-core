class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.1.18.tar.gz"
  sha256 "8c1db23c5ad44c6410874161e78f785475d3f08ed0daae57fe56c44e33a89c0f"

  bottle do
    sha256 "2461a9457ed18b62c945abd232ac9cb84d386d412b4bacf1a631a38d17349366" => :high_sierra
    sha256 "1fd08fdc849eba505862062dfbf7216d04b6482404ec3827f7331d6205016e26" => :sierra
    sha256 "a0f4fad40dd95080f60d4abe85be7287593a9c32cce6877a4f0384d9eb00ae72" => :el_capitan
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
