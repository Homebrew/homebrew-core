class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.9.0.tar.gz"
  sha256 "952d8b7c9d8a6decbf6f77164728fac6d60bfa1857acc0df8c5404500d0f11dd"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?dnsperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f5fe8421406e1c6d506c5d9e83d5b9256935ce34e443286f1c2162dd3f4fc8fe"
    sha256 cellar: :any,                 arm64_big_sur:  "a3987ac2cbf7f703623d31962866146794453c00afde10892eeba979c8cdeb3d"
    sha256 cellar: :any,                 monterey:       "afe4e17621d4201df2a5bc5da377f330d89e1b80d7ecbbfb37c9020175aa46f1"
    sha256 cellar: :any,                 big_sur:        "fd360d4eb9f870d1e69b4dbfcce4f8c6ca6449937ce7006d392eed24a7c23926"
    sha256 cellar: :any,                 catalina:       "aa03ee74c9117ead14fc42dfed419e404cc48e232ddf8b898ebb3925ec8ab89d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26ff62ca6ede5ad01175e0035145c6f4680fa0e9a742f6bfd2d16f415aed6b4a"
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
