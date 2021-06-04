class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.6.0.tar.gz"
  sha256 "7d5e0a41798b02b634ad80401b71efe51ff5cfe3c07e1030149cf5772c45b72e"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?dnsperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ef54bb098cec7337125aa3467c8ecf98d2fb78fdcd241ae037ea23fefcd573a7"
    sha256 cellar: :any, big_sur:       "3b8e3c295bf3e25a27e3f94df39ebbc961ef4db9042682f54a72af05bd04b81d"
    sha256 cellar: :any, catalina:      "f1233b930f07f50f522ce62927580eeea780dc8b6143b1f6c9b29ca76991e862"
    sha256 cellar: :any, mojave:        "4faa3586b9198b874e26b3dddf89ae5579ffcb14e7f475bc46f7bf7df98f160c"
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
