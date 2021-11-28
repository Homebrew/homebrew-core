class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.8.0.tar.gz"
  sha256 "d50b9e05d9688a7b5906447cdca87bf1d8e100b5288e0081db6c3cdd0fea19b3"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?dnsperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ad89e7f087e2e1f0b4301d3a16617acc4985974bd254b672ba67f568f093b857"
    sha256 cellar: :any,                 arm64_big_sur:  "260a0a5d5afd63cd2a91ad387c37de2f03e12f729825711ae288eb978683bb18"
    sha256 cellar: :any,                 monterey:       "f25a50c54ca6b786a64c5e4f655b0265574f7c82edbcf209136c8c2b8a1c1de6"
    sha256 cellar: :any,                 big_sur:        "6652eac70d6ae82c787380e9474211f4d7d5adfdc2c3802b91e63abe7c671a83"
    sha256 cellar: :any,                 catalina:       "1842aa638a4165177219d6e6693cf887fad4570711f864253c9e60e5f4389952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b18e1de1c524e0549f9b649395ab9c40cf3b3a3dc25ba8d2323fc3f9d755216d"
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
