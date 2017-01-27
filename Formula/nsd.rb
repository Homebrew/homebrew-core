class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.1.14.tar.gz"
  sha256 "bdfc61c5f3bf11febd8f4776eef1d4f2d95ed70f12f11d4eeee943c186ffd802"
  revision 1

  bottle do
    sha256 "2c32b662005bd31ed1b30aa49d41e8c26a380458f3c78aae228d3563523ff4fb" => :sierra
    sha256 "5d1e2bf45d371b22971e5028d8c860f0471aaa266ca1f67908dd882f0a9e2174" => :el_capitan
    sha256 "7b20d9bf9cbd53ce7890d48c67c36cff714655ba35d411f418b792a49e8d5e46" => :yosemite
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
