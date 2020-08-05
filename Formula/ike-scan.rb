class IkeScan < Formula
  desc "Discover and fingerprint IKE hosts"
  homepage "https://github.com/royhills/ike-scan"
  url "https://github.com/royhills/ike-scan/archive/1.9.4.tar.gz"
  sha256 "2865014185c129ac443beb7bf80f3c5eb93adb504cd307c5b6709199abf7c121"
  revision 1

  head "https://github.com/royhills/ike-scan.git"

  bottle do
    sha256 "11f8717a655e0279957d3b4464b5074e1b75b17d0b882a93c9375b116f513deb" => :catalina
    sha256 "684cd449c88f873dec2719d9423f42732006631b923aec133c5c2a447895b241" => :mojave
    sha256 "9be05676d382198f99911601aa83008e5a27371669728c4d70cc98e9564bd2f3" => :high_sierra
    sha256 "cd6e8435040dd728e6dbd62c161d0c6b48d19e0f5fe69ce9bef48991cccb91f1" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    # We probably shouldn't probe any host for VPN servers, so let's keep this simple.
    system bin/"ike-scan", "--version"
  end
end
