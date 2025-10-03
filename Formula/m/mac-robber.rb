class MacRobber < Formula
  desc "Digital investigation tool"
  homepage "https://www.sleuthkit.org/mac-robber/"
  url "https://downloads.sourceforge.net/project/mac-robber/mac-robber/1.02/mac-robber-1.02.tar.gz"
  sha256 "5895d332ec8d87e15f21441c61545b7f68830a2ee2c967d381773bd08504806d"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "99a169217c9e38f7b17c74a953fe179c4ac781f840b2bf54d697af3cc5f6e21e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "872680f432b3c3542cf35f30795d0bb9cf0e03c12aacd2522644d0c2f56f2e4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "857246f4d354a3df452fd928e59e15667f3e713928c1da2fd207e3163892ffdb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a95d6147c4806004b72f8dc70e77a4d3bcb4697dbf991193289facbf4d7b296"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79d32b7d6cea8d48155f51c6f95ac062b0f905ccc2538b07674118a23371807e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b884509ff648339c4d66a27fff082ac80b7762c831ae9aa5599419c68d86cfd"
    sha256 cellar: :any_skip_relocation, sonoma:         "224025cbdd0d6d77a208e36caf9f375b760038101f242d5bc0d0e1bf077a6d25"
    sha256 cellar: :any_skip_relocation, ventura:        "5e6711eddd41368e2988dc8d834e0ff2470d9de53576bbb3a9ee757757f4a190"
    sha256 cellar: :any_skip_relocation, monterey:       "9a0cd671a8a723dc4a8207cfc7e5f08628d2cadda34debd8554a92beb3ad2ed5"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cba6aa1a9eeca9b46559e0592b2b667d84d99f344781bce1b994aa5ad7a6e05"
    sha256 cellar: :any_skip_relocation, catalina:       "cb1d422835804b5ea784a2b9157ae77a0940902771397b235d4ad784b88f961a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f1de023a55e034e053a0b9def5895de322fb65c50bbed184391cb1d7e98f877b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac53384d4cfcdf2b78d8abc6e8882ce7e6efd95304a9f09895a9e8a6108a4a9a"
  end

  def install
    system "make", "CC=#{ENV.cc}", "GCC_OPT=#{ENV.cflags}"
    bin.install "mac-robber"
  end
end
