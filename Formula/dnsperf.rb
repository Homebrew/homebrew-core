class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.11.2.tar.gz"
  sha256 "a78d9c52d0cac43fa693f657523f3c98de90083b1ac14153d67e75ddf84143a5"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?dnsperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "657021dc6af2a8b940725c50104f8c7cea4906b20fb283472fec2c999d28f2df"
    sha256 cellar: :any,                 arm64_monterey: "51dd78d450f2f627f73cbb3e93dbffc0aaa302261e6db2f7abcb75a42a8b01c8"
    sha256 cellar: :any,                 arm64_big_sur:  "55a5deae1dd129ceb661450e6c427790b5278f2cac41bd7fb3531c9197d219f0"
    sha256 cellar: :any,                 ventura:        "a2cc30a0d196b124a99bdd6f385806127b222e28d951665c3f6a1cf74f587adf"
    sha256 cellar: :any,                 monterey:       "024594ec19b5ff7d061ee646da19710526c39b58181bf33e65060929c18eed73"
    sha256 cellar: :any,                 big_sur:        "6b0223a9c9fa5a7fb63416db73ef725f11a897f51f448b34c192bbd314529311"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2887bc6749544311e1ff459f8add0e55da1fb5eaf4683dfcb71c7bdb920da7d5"
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
