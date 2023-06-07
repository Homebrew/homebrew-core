class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.12.0.tar.gz"
  sha256 "1ff94f71ac8b6274042ba9ee62402bdd57d7fc4795c5d7135bcce1660584cd43"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?dnsperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "07255e48c7b4dcecedeaee68c30d02b40b6a99732b3e585a012ee29aea47ead5"
    sha256 cellar: :any,                 arm64_monterey: "5d2aa2d54126bc683851bee9a8a9114ce21904e9ea162b91bdb28dd49b56f777"
    sha256 cellar: :any,                 arm64_big_sur:  "325cbb48fda4a3807b7418d919fd37b21f375cd2f02f3959484dbeeec605dde2"
    sha256 cellar: :any,                 ventura:        "43af4673c22817a9c02523f06d910b645fe793acbf1f206980dbd649da6f43c6"
    sha256 cellar: :any,                 monterey:       "ca73035b70767b822b9c69cc3f7121ea0820b9c8fdefa2098c2e39035420c30a"
    sha256 cellar: :any,                 big_sur:        "fd1aaada106bf29fd8b4fb24f103b72b0b2b0ace1d81161d7721f65c592b3c1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09b42aee67155fe82691368c304e1b0089aa221ad87637f37781684cfe9a8a24"
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
