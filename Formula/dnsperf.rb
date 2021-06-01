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
    sha256 cellar: :any, arm64_big_sur: "2378d55fd33b60e2753a9722f6bbca621431f8a61371cd6ab76f07408de1a134"
    sha256 cellar: :any, big_sur:       "a77ae80a638db1c98cfef90545786ee5d2a1e9c1b7c23f2799d49d8ee31120b4"
    sha256 cellar: :any, catalina:      "81a1ab59e0d6c431444e136ddb7d2936d58c881c4306a6d9ecf6e631240326a3"
    sha256 cellar: :any, mojave:        "d5397fd90812d3317bc0e981db16435a1a74dbbb112d7ff2a3f96c94b903b84b"
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
