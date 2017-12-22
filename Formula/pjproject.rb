class Pjproject < Formula
  desc "C library for multimedia protocols such as SIP, SDP, RTP and more"
  homepage "http://www.pjsip.org/"
  url "http://www.pjsip.org/release/2.7.1/pjproject-2.7.1.tar.bz2"
  sha256 "59fabc62a02b2b80857297cfb10e2c68c473f4a0acc6e848cfefe8421f2c3126"

  bottle do
    cellar :any
    sha256 "5770d82ed52ea4b5e088727cd1d114e715050a0c6892bafc01df4728bc2846d4" => :high_sierra
    sha256 "e7983a5219531a614a7eb6c0b42d8c450671458cf215e3ca0da4347ba3ae419d" => :sierra
    sha256 "b9a1ed9413cdc1a3c9997bfa710567e9feb7945719391bac3c494eb384924b6b" => :el_capitan
    sha256 "a9cc70c5cfb1ba336de7caf9fbe4cf2cb39230e75600c7cdf1709060a4931f42" => :yosemite
  end

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "dep"
    system "make"
    system "make", "install"

    arch = Utils.popen_read("uname -m").chomp
    rel = Utils.popen_read("uname -r").chomp
    bin.install "pjsip-apps/bin/pjsua-#{arch}-apple-darwin#{rel}" => "pjsua"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pjsua --version 2>&1")
  end
end
