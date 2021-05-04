class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.5.2.tar.gz"
  sha256 "0c3b7b51521a7fbd1ac54d73cf883f048197343ea1bb7b3eaf244952284ac0cf"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?dnsperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8730e011c11d6122dc29b6394e581a0470e026ecd4e817f826514ebd7b6fcc82"
    sha256 cellar: :any, big_sur:       "a28b5ac11a2d5163a91313749fd8ddd960ee6ca7f196b652927bbeb195989ffd"
    sha256 cellar: :any, catalina:      "b84cdea5d717093c0d5221c95793c69dd338f7ade5606ad4a83f28695dc4cbbc"
    sha256 cellar: :any, mojave:        "eb49eb5b1be6846b2c6bafd8a42a8e23275214ba2737ceefd640b5bbbf65e3d9"
  end

  depends_on "pkg-config" => :build
  depends_on "concurrencykit"
  depends_on "ldns"
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
