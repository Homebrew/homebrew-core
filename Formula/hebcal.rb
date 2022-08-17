class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v4.31.tar.gz"
  sha256 "0a083aa0f4e561987f15914c1d6807a5107eb7e7f2e981aef5725130a36893cd"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6858b58451056d5b885ff20511769f4157a1c90a9de07f5d0f6c7724e9084844"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5aa1e58ab697e42039660251d6512940c45aa058d040e53b7042758841fcb369"
    sha256 cellar: :any_skip_relocation, monterey:       "92fb89a3ebeb16ca08dc6beacc2e54ed566e4069ccbdbf26bebc3a920bb774de"
    sha256 cellar: :any_skip_relocation, big_sur:        "d13168e7d833058699c3090d9b92bf6a52bf33eb19ec44a7c8821b288aea71d5"
    sha256 cellar: :any_skip_relocation, catalina:       "aa2c7f4e49fa685a6280e0426027176f737d43a94ceb4cc4fdf18dbaf6b3f274"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cae6a21f371bf895ab49451d470033dba72f5d1ffbe4f116ee87b493370c9ce"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  uses_from_macos "gperf" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}", "ACLOCAL=aclocal", "AUTOMAKE=automake"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
