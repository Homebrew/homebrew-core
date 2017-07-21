class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.1.17.tar.gz"
  sha256 "107fa506d18ed6fd0a922d1b96774afd9270ec38ec6b17cd7c46fb9433a03a6c"

  bottle do
    sha256 "abf50b3b34010f65790fe3506d44428d9cfadb9fbe2694b743a877f373fcaa64" => :sierra
    sha256 "6476acc0565439cb72bf274a8c9adf1d73289e9617e5734b73c1601d2c15c27f" => :el_capitan
    sha256 "a587267cbf3d022e9996b26b0a540873cda9510be52b0d74a94ecf0f1e8a40ea" => :yosemite
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
