class Ondir < Formula
  desc "Automatically execute scripts as you traverse directories"
  homepage "https://swapoff.org/ondir.html"
  url "https://swapoff.org/files/ondir/ondir-0.2.3.tar.gz"
  sha256 "504a677e5b7c47c907f478d00f52c8ea629f2bf0d9134ac2a3bf0bbe64157ba3"
  license "GPL-2.0"
  head "https://github.com/alecthomas/ondir.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a1cf9bc1e18b613e3b481b935f000c593acd83310b808ec7fd64b9d21a14703"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7145397ec79d9811f95dce65de062f977d3c0bc6d707cf251dfad0d46ac7ba75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "135b0885a206244ce74e430ac0f2131b92742481d81f7774cc25377ca8da4b1e"
    sha256 cellar: :any_skip_relocation, ventura:        "c7c513def5b74de78d947c2e3b84e2534f23bf134a01b282751adb58b506823b"
    sha256 cellar: :any_skip_relocation, monterey:       "7acbd1cdad05caabfe0af821c2c1db0bea782e89d2f81547efc33aaefcca4563"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ba9a457a52f2964f6c831a192f8c107d73c96b5868d2a3d84cea954b2b33860"
    sha256 cellar: :any_skip_relocation, catalina:       "99ac333a6908b1862267764e69850b8f21b9ed160e271719393eb82e83becf42"
    sha256 cellar: :any_skip_relocation, mojave:         "d0887254ee09aa205791efded5cdec39cdd2d997132fd5b4bf3c7fa4c4f90337"
    sha256 cellar: :any_skip_relocation, high_sierra:    "5f1e570b6cd0ef892deaf6f04c90d752ff976dcca8d3be31d6d6ddb546241995"
    sha256 cellar: :any_skip_relocation, sierra:         "90e85060a76337368083c889379b71cda5994ab163b73337050819472f41800c"
    sha256 cellar: :any_skip_relocation, el_capitan:     "8d841a2a8b98a512265dc05deb3ea74e7458a4d5412da786f595c31420b7fadd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95edf0af760fd088984a5f226ac2e61ee6b6280a313489acc9235f2fc381ad14"
  end

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
