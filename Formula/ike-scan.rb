class IkeScan < Formula
  desc "Discover and fingerprint IKE hosts"
  homepage "https://github.com/royhills/ike-scan"
  url "https://github.com/royhills/ike-scan/archive/1.9.4.tar.gz"
  sha256 "2865014185c129ac443beb7bf80f3c5eb93adb504cd307c5b6709199abf7c121"
  license "GPL-3.0-or-later"
  revision 1

  head "https://github.com/royhills/ike-scan.git"

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "80591b7e93871241c3a15afa6c7be4df8df8f2c8fb1b6cc1a54be3a3c93645b3"
    sha256 big_sur:       "9f721c4e99f22ccbf204f54c78a6b4ff7bef621dc4590673240b5a31dab268ef"
    sha256 catalina:      "a06543751eec6b9d198c3826ea62743a0ee12a4479bf28efb41209a0edea19be"
    sha256 mojave:        "acc102b6014ee8216274afb3a0b10460c71f0059a7aeca732dfad848c7dd2846"
    sha256 x86_64_linux:  "e954d09eee1f1afdf2b70d915559cf804bf97947568fc4972a39af5298e5769e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"

  # Fix Xcode 12 build: https://github.com/royhills/ike-scan/pull/32
  patch do
    url "https://github.com/royhills/ike-scan/commit/c9ef0569443b03fda5339911acb8056a73c952de.patch?full_index=1"
    sha256 "890a60984c7e09570fe0b3a061dc2219bb793586bdf49ebd5dd338b3690ce52a"
  end

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
