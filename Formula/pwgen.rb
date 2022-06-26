class Pwgen < Formula
  desc "Password generator"
  homepage "https://pwgen.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pwgen/pwgen/2.08/pwgen-2.08.tar.gz"
  sha256 "dab03dd30ad5a58e578c5581241a6e87e184a18eb2c3b2e0fffa8a9cf105c97b"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c66f05513440592d1642a258992d076ff1b3c86f3646c88861aa0f4e443f6b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc4d1e845384c5170c9fd6e9c5b054e152b8690763a55b3c9a1a0e51fbee31c4"
    sha256 cellar: :any_skip_relocation, monterey:       "d83b242a43d7403f540e56a85399132205a38f5972e8eb2b8744e709b1da2bf4"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a47de6eec09b1a2e938da0bebca8386261bb63040f9ca77fadfc3d28db7efc8"
    sha256 cellar: :any_skip_relocation, catalina:       "725911d1fd71b259acb7b907c09ef86a03545afe95e161856130992fc0789ffc"
    sha256 cellar: :any_skip_relocation, mojave:         "2f35a2d575e16a2ab0497cabfc927a7b40aba68edba574889bf9bbdf03572c12"
    sha256 cellar: :any_skip_relocation, high_sierra:    "185f2f56eb03da60277520734452204ec2e0059cbc1f0af5d0fec1e7fa837658"
    sha256 cellar: :any_skip_relocation, sierra:         "01a0709f74923e7b86d680f03d3ec056d3175cb7e54be176a26d5bfae890fd21"
    sha256 cellar: :any_skip_relocation, el_capitan:     "7dade70b172cb91635afffe8bb1eadb251f9dbd3368ab9e4a37f98a7c0a14b01"
    sha256 cellar: :any_skip_relocation, yosemite:       "1799bdbb42974d10e2ff3a4e382351b1f03f0a3be31c15ff718d8935d1226101"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d869f0f3b08bf09648754a037fedc9a729b1b5e718bc366e2cf9a7cca2861813"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/pwgen", "--secure", "20", "10"
  end
end
