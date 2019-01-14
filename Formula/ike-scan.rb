class IkeScan < Formula
  desc "Discover and fingerprint IKE hosts"
  homepage "https://github.com/royhills/ike-scan"
  url "https://github.com/royhills/ike-scan/archive/1.9.4.tar.gz"
  sha256 "2865014185c129ac443beb7bf80f3c5eb93adb504cd307c5b6709199abf7c121"

  head "https://github.com/royhills/ike-scan.git"

  bottle do
    sha256 "d6deea8b99eb570833d63feb09776a3fc1584ce83f78808fe0730aec8cacc467" => :mojave
    sha256 "67c79247795879dc39dee4f7264f9665e5fa5fb4b5e75a9f153d1dffa1cc88ce" => :high_sierra
    sha256 "49efb4387beb1f0edcba655b845f74b802e4b2f4fb3b57028b59fa3b44717e74" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    # We probably shouldn't probe any host for VPN servers, so let's keep this simple.
    system bin/"ike-scan", "--version"
  end
end
