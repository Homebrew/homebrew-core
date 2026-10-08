class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.16.0.tar.gz"
  sha256 "6bccbd6949a4616442fdabb8a93d20011f5fbc2e5492d467e612a16aa39426e2"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?dnsperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5402565be8b07a568373471c143d4a7eec13c91cc9b617f03a6071449add98ee"
    sha256 cellar: :any, arm64_tahoe:       "c195ad0dff7969dec034ab5e086b07fa80853c718223321dd3560c074d65a0f2"
    sha256 cellar: :any, arm64_sequoia:     "6713ae9ae290efd443d780fbd5a31f37e4f66c4c15f3bc7ab99f81e6a4422af3"
    sha256 cellar: :any, arm64_linux:       "6a5d6ce3a7c200313d4f8c3f75af09bf4951225c1b887112eea16ecfd8ebb0b0"
    sha256 cellar: :any, x86_64_linux:      "16487f0b83a84acf794cc4d5561e8e6c537b0045e962d4641925a2de9cb3cb7d"
  end

  depends_on "pkgconf" => :build
  depends_on "concurrencykit"
  depends_on "ldns"
  depends_on "libnghttp2"
  depends_on "openssl@4"

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
