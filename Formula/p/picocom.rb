class Picocom < Formula
  desc "Minimal dumb-terminal emulation program"
  homepage "https://github.com/npat-efault/picocom"
  url "https://github.com/npat-efault/picocom/archive/refs/tags/3.1.tar.gz"
  sha256 "e6761ca932ffc6d09bd6b11ff018bdaf70b287ce518b3282d29e0270e88420bb"
  license "GPL-2.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "01b35b20e38a3e06f20de103d7d5b371386fce19b8bab8d6869886c5eb09f329"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "87020c916b8770f7458f4ab8323909d2ed5e1d48706507a2a262289f741ab627"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3a7594ede879b71828a7e5b36cdcccb7e208001d4514c4c8e8367146d561c7ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10704a0718469ac5d0d1b0774341b0c24d9ddeb1a5e6d2d12deb916d27bc3506"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f286430d43b8e36f2abefdf1765e960f76e2bf2c3e04f3e6fa500fa0b8dafeb2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea502c2c427d1e389d7dd0822e6f01d6ac7b7eed6f856ee9f9e60fbd598ee845"
    sha256 cellar: :any_skip_relocation, sonoma:         "3359c21097ce36c5ca591b893388abe1b326002e32fa282d9e9b11905936b370"
    sha256 cellar: :any_skip_relocation, ventura:        "7e0e2b6e676423624e67f67a7f509332b6aa118e860c92f32308f9399405d87c"
    sha256 cellar: :any_skip_relocation, monterey:       "0b964f92ff9ba91ad3107dc9c435de2198bf8f37f72414ec71d6f269293144a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "bcf999f8a55184741845fe1dbab36597c3be6723f4fa4f603ee453558bfd6170"
    sha256 cellar: :any_skip_relocation, catalina:       "dbbf7829cd18b6fc0b4cf2296de575e7399702fcad52a6da94280e30e3abc341"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "98708de364229e523e74c4d15f335fe1bf758bd26c12f78fc145fc464ff3130b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c765edf56732a7dd0631c12068fd17ba7800c98ceb24f98fa65990e7fa13dadc"
  end

  # Upstream picocom supports arbitrary baud-rate settings on macOS out of the
  # box, but only applies that to i386 and x86_64 systems. With the advent of
  # arm64 macs, it is now necessary to expand that support.
  # https://github.com/npat-efault/picocom/pull/129
  patch do
    url "https://github.com/npat-efault/picocom/commit/f806bf28266cccdb75ba89d754de8d8fa64c6127.patch?full_index=1"
    sha256 "b1a29265d5b5e0e7e7f8f3194b818802de8c7d18e80525bc43cbb896a6def590"
  end

  def install
    system "make"
    bin.install "picocom"
    man1.install "picocom.1"
  end

  test do
    system bin/"picocom", "--help"
  end
end
