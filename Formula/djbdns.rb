class Djbdns < Formula
  desc "D.J. Bernstein's DNS tools"
  homepage "https://cr.yp.to/djbdns.html"
  url "https://cr.yp.to/djbdns/djbdns-1.05.tar.gz"
  sha256 "3ccd826a02f3cde39be088e1fc6aed9fd57756b8f970de5dc99fcd2d92536b48"

  bottle do
    rebuild 2
    sha256 "f74830dac0cdcd4baf0dac7a091dcab0352821d894aed49f8e0a6fad1b240c2a" => :high_sierra
    sha256 "bfb5b8aa8d1e0c6a3d4789ea5c650c920576d0d21a5c623414119139e06084a0" => :sierra
    sha256 "f15150f288f8769a34c39a5cd27052c2b7828fcc10fdd3832473fc995d82e1f6" => :el_capitan
  end

  depends_on "daemontools"
  depends_on "ucspi-tcp"

  def install
    inreplace "hier.c", 'c("/"', "c(auto_home"
    inreplace "dnscache-conf.c", "/etc/dnsroots", "#{etc}/dnsroots"

    # Write these variables ourselves.
    rm %w[conf-home conf-ld conf-cc]
    (buildpath/"conf-home").write prefix
    (buildpath/"conf-ld").write "gcc"

    if MacOS::CLT.installed?
      (buildpath/"conf-cc").write "gcc -O2 -include /usr/include/errno.h"
    else
      (buildpath/"conf-cc").write "gcc -O2 -include #{MacOS.sdk_path}/usr/include/errno.h"
    end

    bin.mkpath
    (prefix/"etc").mkpath # Otherwise "file does not exist"
    system "make", "setup", "check"
  end

  test do
    assert_match /localhost/, shell_output("#{bin}/dnsname 127.0.0.1")
  end
end
