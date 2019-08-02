class Nsd < Formula
  desc "Name server daemon"
  homepage "https://www.nlnetlabs.nl/projects/nsd/"
  url "https://www.nlnetlabs.nl/downloads/nsd/nsd-4.2.1.tar.gz"
  sha256 "d17c0ea3968cb0eb2be79f2f83eb299b7bfcc554b784007616eed6ece828871f"
  revision 1

  bottle do
    sha256 "3250e2ea3d7df98039a3919486f16c0bb99e5a422d8bea10026d6bbe4a753ce6" => :mojave
    sha256 "88b8ee17c51518879af146321551c52010bfc214e3dc8e81f612efd1ff78e520" => :high_sierra
    sha256 "840fdf5d9daf7940c587b5bc571b29bb1670cb4a7df539b32553b6308d357e10" => :sierra
  end

  depends_on "libevent"
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--with-libevent=#{Formula["libevent"].opt_prefix}",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/nsd", "-v"
  end
end
