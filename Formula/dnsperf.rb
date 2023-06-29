class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.13.0.tar.gz"
  sha256 "a31caa1899c67f35f28b970abe1f31f1d9c6b1f8b20ea24187ca1a82baac53cb"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?dnsperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "be46ad0c98cf9615c5856fa8dd690d0a9dcf2a06f1f46bebc20851668ab52a30"
    sha256 cellar: :any,                 arm64_monterey: "b89bcceb9ef38b5eb14699a212d9808c11395e8aefc91c353f41bf2b8d56abe6"
    sha256 cellar: :any,                 arm64_big_sur:  "e2017c6ce565d3316ee3a5be2f5b6e3001d89d2d898b7115fe69a313fffc248d"
    sha256 cellar: :any,                 ventura:        "197737e13f99489490fd60378f40ca685dd391c2cf689544f5758475c5c14a7e"
    sha256 cellar: :any,                 monterey:       "65089b4e579d3d98277f3a0f3db60d2310e6a668f638df21437eb8a560281c97"
    sha256 cellar: :any,                 big_sur:        "702d2a9288a3e832d9575c169964e376ed758aa7299c54366466bc8f273e2521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b91fed1b250487eb342425a70e796656c3d56b40fbe352cc86ac17949080cd9"
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
