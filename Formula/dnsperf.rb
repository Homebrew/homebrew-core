class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.8.0.tar.gz"
  sha256 "d50b9e05d9688a7b5906447cdca87bf1d8e100b5288e0081db6c3cdd0fea19b3"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?dnsperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f06383bf7ab68f519f5b7037e31dedad98c77857cf475ef800e842321627e689"
    sha256 cellar: :any,                 arm64_big_sur:  "740913f29f416d20fe462a5b609358c9331de5a2a79f0555536f5a25a515eb22"
    sha256 cellar: :any,                 monterey:       "4144d2024ed40fcd9b6e8684edd476c1a5a3b6077a600cb929043c067eaa8dd4"
    sha256 cellar: :any,                 big_sur:        "fc969607e2baacfcf5f14cc7f7338b25c147a76d01718b2055efe6b9b2df2d69"
    sha256 cellar: :any,                 catalina:       "01eb44eafb115cc6d3c688d79014a972c4b3bf9b4121349de6f9d71b458bc04b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dfc2db092504211f547c184efbbaf3625175f9f6bd984528848f879f539fa0b"
  end

  depends_on "pkg-config" => :build
  depends_on "concurrencykit"
  depends_on "ldns"
  depends_on "libnghttp2"
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
