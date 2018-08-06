class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.1.23.tar.gz"
  sha256 "f60ed8bd676b94a1c83c4335e8a51d61baa1a952660ecf21673a1414244b85fd"

  bottle do
    sha256 "512f724096dbeccc2ccbb1a0ba8ba7981738d02a95130ff45bf5919a13583b53" => :high_sierra
    sha256 "e5ecca18f8d7dd7c492c731d99a06657dba4ce4fbd9eac85bdd63374c8986c10" => :sierra
    sha256 "14c63a324467c83baff7caeed843b3364eb49ce7f7d98097bf4b1d049fabdf04" => :el_capitan
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
