class Apparix < Formula
  desc "File system navigation via bookmarking directories"
  homepage "https://micans.org/apparix/"
  url "https://micans.org/apparix/src/apparix-11-062.tar.gz"
  sha256 "211bb5f67b32ba7c3e044a13e4e79eb998ca017538e9f4b06bc92d5953615235"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "185b92258d1ca2a1aeb6cb068f1fc1fdd13415aa3f730fac1eaa998fef099653"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "376d5af089ec2f8fc405e043142976cff8f2005b0338711e572008062298326f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6fddf44a334a107525c10d79840a52c7298a822e39aa74a6b12d713b9a59bff"
    sha256 cellar: :any_skip_relocation, ventura:        "f8146185bc73258782bfed5b8155d7f20bcaf74cbc14de2ecb94316247e397be"
    sha256 cellar: :any_skip_relocation, monterey:       "7409c547247d36188c88db44981e1b60174b34d627fbf181be554ce25498e4a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7c4e0d0754712277af33217475b179c898bbd965b5bff85f845658791eda9f8"
    sha256 cellar: :any_skip_relocation, catalina:       "27524421291472bcc5ef8dc6a19d7b6cb7aab1d6a7dffd326c4594a11f3ce4e8"
    sha256 cellar: :any_skip_relocation, mojave:         "5b26fe074f048cdf1ba973e21e91bd51eb7f275ba05928ffaaf2e56c15671bbd"
    sha256 cellar: :any_skip_relocation, high_sierra:    "1170198d8bafd2b2a6795257dec1e4c15cb1c92d1af7eea44ee816c0a58ac8a1"
    sha256 cellar: :any_skip_relocation, sierra:         "889da718a73f128fa8baaca4a66ae80316ef6cb00ccc03937ea191c8eb781930"
    sha256 cellar: :any_skip_relocation, el_capitan:     "89d7d52f9f2e76f1dd6b91075f407fa71000be0b09bd4548c11a6fd820b87ab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0597c7147ee8a66fe491ccb3e8c386e1580953cc1eedbc9ddbb0349037f312d7"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    mkdir "test"
    system "#{bin}/apparix", "--add-mark", "homebrew", "test"
    assert_equal "j,homebrew,test",
      shell_output("#{bin}/apparix -lm homebrew").chomp
  end
end
