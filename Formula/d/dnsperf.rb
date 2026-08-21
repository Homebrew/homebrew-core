class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.16.0.tar.gz"
  sha256 "6bccbd6949a4616442fdabb8a93d20011f5fbc2e5492d467e612a16aa39426e2"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?dnsperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "55dbe83bfb15214ebcd5fa402abba5475378675a2c0856082955180c31ed26b2"
    sha256 cellar: :any, arm64_sequoia: "11d7647724bf2f4043cd16ebcc992527336cbed796ba2b20e349dc53cf343f68"
    sha256 cellar: :any, arm64_sonoma:  "e80e9d8650910629e3a306b996a8ec1fb0730fe7160a35132e9c57986d8df6d0"
    sha256 cellar: :any, sonoma:        "ac20151e4d27e204ba9f0d60e4a7fe63ad0872e594e5fa9a1e51cb141ecb5110"
    sha256 cellar: :any, arm64_linux:   "610b527f179d2b7003ae6660ec9a8b95ad7492d60040c1a53057cb6557ed03c0"
    sha256 cellar: :any, x86_64_linux:  "024e4615079d9030e8ee00147a7da83719685b1974f3ef71da98a6b5bf977f7f"
  end

  depends_on "pkgconf" => :build
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
    system bin/"dnsperf", "-h"
    system bin/"resperf", "-h"
  end
end
