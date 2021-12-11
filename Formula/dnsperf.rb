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
    sha256 cellar: :any,                 arm64_monterey: "8d3f6d75a68fe00c1578548401dc968b73378bca9a721144b455710d6a4cb6fa"
    sha256 cellar: :any,                 arm64_big_sur:  "1b1c28921c6bbc4f394bfcec35624aa30610fe1313c4d849fa60091223afb66d"
    sha256 cellar: :any,                 monterey:       "676a3977b93804d60bcbbbd0957fc7e494847b1c18a70d4e5ae493e9407e2fec"
    sha256 cellar: :any,                 big_sur:        "b664c2f85d3874fc0a8735afbb1c31f3d850079808859e01c4502aea5cde7fb9"
    sha256 cellar: :any,                 catalina:       "5cd51f33467d771bd06a6ded38f93bec49b3a951dbfdc3350dda14c599c70545"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d15a369d9d82a39408723b1100433513abc0ecffa333d641e01b955e45844e7"
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
