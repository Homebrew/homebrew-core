class Djbdns < Formula
  desc "D.J. Bernstein's DNS tools"
  homepage "https://cr.yp.to/djbdns.html"
  url "https://cr.yp.to/djbdns/djbdns-1.05.tar.gz"
  sha256 "3ccd826a02f3cde39be088e1fc6aed9fd57756b8f970de5dc99fcd2d92536b48"

  livecheck do
    url "https://cr.yp.to/djbdns/install.html"
    regex(/href=.*?djbdns[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 3
    sha256 arm64_monterey: "eb8f1b169c2ef3b24defe00ef952b8dab42b45d42517bce471aa6e9016c7b4b6"
    sha256 arm64_big_sur:  "62ab5e22e0c15787a98c84f23905dd569067cd4376dc8c472509ac5ee5d24955"
    sha256 monterey:       "e31e528e17b73be225ea467a43d2e1c997bfac8a9adb723d7e3c48595f13ca5c"
    sha256 big_sur:        "1231622a14007c9ec76ef137a5e1a42a30ce4192b0fbba0cf768f981090059ce"
    sha256 catalina:       "5b473b664d7370f2e838bd496555841e20a8ef13aaeee6b312fc6501911b7fe0"
    sha256 mojave:         "b57557c57ac07e053f78b2e73aed4cc9ec72a0c89d68e4ca8bc1dd3b2b9cddba"
    sha256 high_sierra:    "f6555710c361d47fabfeeb6d8148b84c3a7e973ba4407def4f0a37e327ac3a5b"
    sha256 sierra:         "ce72334aa541af3a486f90e32b2162ba8b5c86825f0a52f1b6de9cb33640eeff"
    sha256 el_capitan:     "9bbf4356e0bb4e25827fdf02d4efa0fc3763600456ad76e63f662dae6e1fb4ce"
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
    assert_match(/\d+\.\d+\.\d+\.\d+/, shell_output("#{bin}/dnsip example.com").chomp)
  end
end
