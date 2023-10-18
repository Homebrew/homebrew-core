class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.13.1.tar.gz"
  sha256 "d3c64afed01adeb7cd52b89166d50ce4d105203132ad09da3a284511530abe80"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?dnsperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d54a248758bd8d8d1246f98846b12501c058db80f10ff4e99c898a65adfcce05"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9d03d7e34c041870345afda0cd2a95bd3b6a2459e7caacbaa88784c3082904c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68b26adc20e0e9e00a3cfe80ce7261ba092ce695dbff99f876556e4f557acc0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c158baa62a0e744502860283fc4e7711fe1315fe1a32bc8f6859b07ea7bc4d2f"
    sha256 cellar: :any,                 sonoma:         "cfcc3cf81e4e0d828f1d68c7b009257bbf5021e1803d8f95ed52df179a19372d"
    sha256 cellar: :any_skip_relocation, ventura:        "e9c4c9abab4cb2895c1ba722841e18a1bb91fe5f82b1ade2ff5a3fe1470dde7b"
    sha256 cellar: :any_skip_relocation, monterey:       "35b4f451bd16df11a9c80e2be717d09333e8d55a58cb98b087f28b71f89dc40b"
    sha256 cellar: :any_skip_relocation, big_sur:        "002e509a7f321ce2d14df8e57b607f1d866f8bc5fbee173fa5431840fa0f251f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8edc4f2e1120b299305b11638419ccb837971e13dcfc1d6fd6263ce881769a8"
  end

  depends_on "pkg-config" => :build
  depends_on "concurrencykit"
  depends_on "ldns"
  depends_on "libnghttp2"
  depends_on "openssl@3"

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
