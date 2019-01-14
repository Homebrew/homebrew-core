class Djbdns < Formula
  desc "D.J. Bernstein's DNS tools"
  homepage "https://cr.yp.to/djbdns.html"
  url "https://cr.yp.to/djbdns/djbdns-1.05.tar.gz"
  sha256 "3ccd826a02f3cde39be088e1fc6aed9fd57756b8f970de5dc99fcd2d92536b48"

  bottle do
    rebuild 3
    sha256 "b57557c57ac07e053f78b2e73aed4cc9ec72a0c89d68e4ca8bc1dd3b2b9cddba" => :mojave
    sha256 "f6555710c361d47fabfeeb6d8148b84c3a7e973ba4407def4f0a37e327ac3a5b" => :high_sierra
    sha256 "ce72334aa541af3a486f90e32b2162ba8b5c86825f0a52f1b6de9cb33640eeff" => :sierra
    sha256 "9bbf4356e0bb4e25827fdf02d4efa0fc3763600456ad76e63f662dae6e1fb4ce" => :el_capitan
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

    if MacOS.sdk_path_if_needed
      (buildpath/"conf-cc").write "gcc -O2 -include #{MacOS.sdk_path}/usr/include/errno.h"
    else
      (buildpath/"conf-cc").write "gcc -O2 -include /usr/include/errno.h"
    end

    bin.mkpath
    (prefix/"etc").mkpath # Otherwise "file does not exist"
    system "make", "setup", "check"
  end

  test do
    # Use example.com instead of localhost, because localhost does not resolve in all cases
    assert_match /\d+\.\d+\.\d+\.\d+/, shell_output("#{bin}/dnsip example.com").chomp
  end
end
