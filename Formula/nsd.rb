class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.1.23.tar.gz"
  sha256 "f60ed8bd676b94a1c83c4335e8a51d61baa1a952660ecf21673a1414244b85fd"

  bottle do
    sha256 "f2bab9b1901fccf428424d55c5320ba0a895c4da277a645fe982666cf6f11cfd" => :high_sierra
    sha256 "6faced9d6bf4fd982feac6ad3ee699c98c3b587289f7d9c1e3141973d4579633" => :sierra
    sha256 "5caa7c0d91e0923272dc123a65317fa4a6c77b971a7c2d665cc0219c51ad61a4" => :el_capitan
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
