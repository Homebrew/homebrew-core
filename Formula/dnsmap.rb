class Dnsmap < Formula
  desc "Passive DNS network mapper (a.k.a. subdomains bruteforcer)"
  homepage "https://code.google.com/archive/p/dnsmap/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/dnsmap/dnsmap-0.30.tar.gz"
  sha256 "fcf03a7b269b51121920ac49f7d450241306cfff23c76f3da94b03792f6becbc"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8967ddec7a8c82711405dcc76f2f5c1908884f5fdd6c59661179448a5beda8ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d8ab01326bcbd1cccc3a2d1a322103b0a19c80d01e6383413befb4d58323c1d"
    sha256 cellar: :any_skip_relocation, monterey:       "bddf6582755a72a1a981c21a6e95f680c3e989d0f65841939bea0a99f8c3a8e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "60700d894e91a2d1f7f06305b1891db380d224ac58d0187ae607b6bab3bc42f0"
    sha256 cellar: :any_skip_relocation, catalina:       "c27b047492145254a37464c3fdebcd656ed25a6e8b0b6d863a5012d00a0d7253"
    sha256 cellar: :any_skip_relocation, mojave:         "4172919faa189face592aa272a8a45b62c05dc3056f75ed26e505d1e35118b5c"
    sha256 cellar: :any_skip_relocation, high_sierra:    "3c45ae4ec1149775df005f3438c0a24971291094bc47814a8a60e4ca67dbce79"
    sha256 cellar: :any_skip_relocation, sierra:         "2015e3fdee32fcdbc0501f522ba720280e8cb07a75f8166fd62a9f876ea12124"
    sha256 cellar: :any_skip_relocation, el_capitan:     "57d5f7ea4a8a73b454bbc60e38fdb9a55e07c2d97f0b5acf38db0408e83b197b"
    sha256 cellar: :any_skip_relocation, yosemite:       "6ede00304c268f3a0013f8aa708f5bfc314acbac1db7a3547e8381dc620b18eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08b6e254381a735136e969dcec42c3de2ec8d54576de2daeb8c7d40d5b4776d3"
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}",
                   "BINDIR=#{bin}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dnsmap", 1)
  end
end
