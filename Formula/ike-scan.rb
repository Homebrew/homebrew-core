class IkeScan < Formula
  desc "Discover and fingerprint IKE hosts"
  homepage "https://github.com/royhills/ike-scan"
  url "https://github.com/royhills/ike-scan/archive/1.9.4.tar.gz"
  sha256 "2865014185c129ac443beb7bf80f3c5eb93adb504cd307c5b6709199abf7c121"

  head "https://github.com/royhills/ike-scan.git"

  bottle do
    sha256 "7e6dde3a63dd30648a77deb4caf5ef6c85d102604a94f0a1db6f7f00e2d7c171" => :mojave
    sha256 "a6497e65e3fd817d9f55e8a92999ea94e80ae8a68e7c7d1aaf00264482f617f2" => :high_sierra
    sha256 "36d4250aba9099fefd630e3a585f4dc035ccb43d53d3270fc41bb08e92242a49" => :sierra
    sha256 "65df0ddc049fadf6c9deb605442092026ec1c4ef5a6358a63ed96928085ac155" => :el_capitan
    sha256 "70276baa029ee6c1a451175e3254cc74754fd5de83fe748d17ba4fcf0586349a" => :yosemite
    sha256 "a0967f6ce6e9903068149c9b379926a25b315c3bdb9aca451f28b0d9cc744abd" => :mavericks
    sha256 "2281b3d5f1f590e69e435a39c1032872db80439411ea74410a58243096645668" => :mountain_lion
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
