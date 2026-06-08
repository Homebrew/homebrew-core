class Apparix < Formula
  desc "File system navigation via bookmarking directories"
  homepage "https://micans.org/apparix/"
  url "https://micans.org/apparix/src/apparix-11-062.tar.gz"
  sha256 "211bb5f67b32ba7c3e044a13e4e79eb998ca017538e9f4b06bc92d5953615235"
  license "GPL-3.0-or-later"

  livecheck do
    skip "No version information available"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "be86c4c318c45b049209995839f8bc3d5fd58d872595672ccd5399e7d081f77e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c47c60a9ddde3d173404c7337080bf1cbd8c8d314b78092f02068a3fa5a689e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15fd7b26fab6e5f2f5d2874ec6d7790b17b6df6fef078d8f2691560e86fb1295"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "185b92258d1ca2a1aeb6cb068f1fc1fdd13415aa3f730fac1eaa998fef099653"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "376d5af089ec2f8fc405e043142976cff8f2005b0338711e572008062298326f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6fddf44a334a107525c10d79840a52c7298a822e39aa74a6b12d713b9a59bff"
    sha256 cellar: :any_skip_relocation, sonoma:         "57755cd04d59e11e725962bb70a274dfc5c732c4020691431d73d1c3f14f7ecb"
    sha256 cellar: :any_skip_relocation, ventura:        "f8146185bc73258782bfed5b8155d7f20bcaf74cbc14de2ecb94316247e397be"
    sha256 cellar: :any_skip_relocation, monterey:       "7409c547247d36188c88db44981e1b60174b34d627fbf181be554ce25498e4a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7c4e0d0754712277af33217475b179c898bbd965b5bff85f845658791eda9f8"
    sha256 cellar: :any_skip_relocation, catalina:       "27524421291472bcc5ef8dc6a19d7b6cb7aab1d6a7dffd326c4594a11f3ce4e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b30647a456f6b9b5d8990f73fc9cf1ef2f4456a666123f396914fb56a136af18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0597c7147ee8a66fe491ccb3e8c386e1580953cc1eedbc9ddbb0349037f312d7"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    mkdir "test"
    system bin/"apparix", "--add-mark", "homebrew", "test"
    assert_equal "j,homebrew,test",
      shell_output("#{bin}/apparix -lm homebrew").chomp
  end
end
