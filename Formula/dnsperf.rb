class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.7.1.tar.gz"
  sha256 "9b4d72aab6713ecab6946ea3d4b69ec694c5749c3a115fc4a006e989c8ed4875"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?dnsperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "678198fb1aaa5f2dc3dce4d0f67e8718c157b0d2ae92045276b342372e3299b2"
    sha256 cellar: :any,                 big_sur:       "d6f96b917152da9251b0b06979829b3f121983fa1832a01f285178682ad12192"
    sha256 cellar: :any,                 catalina:      "d853d198ea4313259676a9d58f8bed21d22be3d39920669d1831ea844e8ff4b1"
    sha256 cellar: :any,                 mojave:        "048f240c955ee77f6e4dc164301b53f75fb82795b143208a10b66a864060d930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64c4130dbb2d5ba767834953760f7ce3fbc96e86219f1bd385831b7096e577fa"
  end

  depends_on "pkg-config" => :build
  depends_on "concurrencykit"
  depends_on "ldns"
  depends_on "nghttp2"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/dnsperf", "-h"
    system "#{bin}/resperf", "-h"
  end
end
