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
    sha256 cellar: :any,                 arm64_big_sur: "e6e0465ecaa51ff3f23300a213452e15b6445202d46932edb43eaafdb5f972bb"
    sha256 cellar: :any,                 big_sur:       "66074ebb530ecf810991edfa0134a265770becd71b0aec017fa25048f0642700"
    sha256 cellar: :any,                 catalina:      "40706d91e1cbcbd4e9ac6cfcf7e4d07f037354077a46efb3c88e35accc433825"
    sha256 cellar: :any,                 mojave:        "585622c32de742da18110e29a74b6a13ad5a74106ba49d4c4a5fcedfa0708fb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff54261899584d2f5d6ce8c6d69b11f06768ad6e45026c0d2a8a9c88c0e6b80c"
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
