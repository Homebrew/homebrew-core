class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.1.20.tar.gz"
  sha256 "8a97f61d7bbb98a2ce04dc4425596f9023677a5f1c5ea743ff408d487f82f713"

  bottle do
    sha256 "c424d27cec3fa434513f7c6e259fe7c70ce7f3050f284b6acfa033e753785b6a" => :high_sierra
    sha256 "a9d32854dab1a8aa5814c57c4d025f7b5d225350129d75d7179f08133d491f86" => :sierra
    sha256 "34efcdbf02f61a9740f1ee8d3e71149dd6f311e62eb3dbd282455980ac664bf4" => :el_capitan
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
