class IkeScan < Formula
  desc "Discover and fingerprint IKE hosts"
  homepage "https://github.com/royhills/ike-scan"
  url "https://github.com/royhills/ike-scan/archive/1.9.5.tar.gz"
  sha256 "5152bf06ac82d0cadffb93a010ffb6bca7efd35ea169ca7539cf2860ce2b263f"
  license "GPL-3.0-or-later"

  head "https://github.com/royhills/ike-scan.git"

  bottle do
    sha256 arm64_monterey: "e2d29c13c00ac946fa360ecca65524a151e342f876fe4515e0bc2abdecccf7fa"
    sha256 arm64_big_sur:  "658bb4d7106e572a7d9a0dae2d6cc9abd4e1007d73ef4ab0ab0ec6f2cbaafd1c"
    sha256 monterey:       "5b806fa9c0134edb2710135e7bcf0ac8d5ac48debfd6286172e6abf687f52401"
    sha256 big_sur:        "debe304378fb8939b606d81a1658f95cb71b9edf538f9e2778385341d66bb3e9"
    sha256 catalina:       "a02fd76ac113a9dc7cb1ed267d221af790abf4f5598a512c1993ea207ad7f6cf"
    sha256 mojave:         "29f357b9b8a36f43410495f79a87e50fcf45507aee242f670182ea7db6630c1c"
    sha256 x86_64_linux:   "16769378c139d0abb2a6c4a05fae1cc1929486d8035c3260391cde66b533b089"
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
