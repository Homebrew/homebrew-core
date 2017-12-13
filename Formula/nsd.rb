class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.1.19.tar.gz"
  sha256 "b0782cb9b57416888d488b6460b071cd85ecb5f99381865b3a7f93dddf9e02c5"

  bottle do
    sha256 "6ef332c3392464989adf52f1024df7c3cc10bcb32f539bffe018d59c979c285a" => :high_sierra
    sha256 "212b8aaf46c6a59c3d75a4125551d84792055fafca9d6981da99935865eefd85" => :sierra
    sha256 "0d5e6414a4bd77ff48fe36530107d7150690b5e9b1666b41fcd9b4a301bfefb6" => :el_capitan
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
