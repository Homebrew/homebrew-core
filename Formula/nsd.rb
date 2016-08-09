class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.1.11.tar.gz"
  sha256 "c7712fd05eb0ab97040738e01d9369d02b89c0a7fa0943fd5bfc43b2111a92df"

  bottle do
    sha256 "112f45f505bacc2f7cc5f05ccb09e770edbfcfdfac03271ab113b2f1de03a701" => :el_capitan
    sha256 "c75e1a7e2fd1351bc037186c35805028998fb095622f8b32fedc47c909972607" => :yosemite
    sha256 "153423b3437b9add7033183bf72329d0c1554d7397bae605b66960bb632ff2e0" => :mavericks
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
