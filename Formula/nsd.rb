class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.1.24.tar.gz"
  sha256 "4fb687c8e494610ad8692a127ac101ed73df851142a42766c33de06e54449311"

  bottle do
    sha256 "ef0ff89248877b6653322d3290897f885cb8d4b48d6eb248acfc8f2d06d56c47" => :high_sierra
    sha256 "762e0ca75b35d762a64149b9e9f748fdd9c3190ccad497643388b9b7f36d3a91" => :sierra
    sha256 "1e5bf01ae719b8588c92d56b59a6d8edab91671f2f38d6c2ddc128220b4d86dc" => :el_capitan
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
