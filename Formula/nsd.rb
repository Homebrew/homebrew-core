class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.1.13.tar.gz"
  sha256 "c45cd4ba2101a027e133b2be44db9378e27602e05f09a5ef25019e1ae45291af"

  bottle do
    sha256 "f1b4787342fd383b1efa321ebc484fa623805c68cbabc054ea4b3ae67bb96f76" => :sierra
    sha256 "fa9ac8a774bf6634d68537c6480b44f142a1d002e05fac0498cb7c8fb994fd60" => :el_capitan
    sha256 "825aa1cb10759370e842aff4f53f7c2df9837a535846b0eb654064b5d9c591d9" => :yosemite
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
