class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.1.16.tar.gz"
  sha256 "7f8367ad23cc5cddffa885e7e2f549123c8b4123db9726df41d99f255d6baab2"

  bottle do
    sha256 "ba4477037250f17c55487ebc1daa2ce1d7f4a2e2a262b6587820a9879cce60a6" => :sierra
    sha256 "833d3da8868b14c7a2742384de1efe863b72c72b9bdd43a0d671c8b521ba7648" => :el_capitan
    sha256 "3e1f1602ed54e8affdf67d952cce6579fd94eb7e0f29173005ddedc9fcaebf8e" => :yosemite
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
