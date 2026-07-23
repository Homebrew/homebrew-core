class Onigmo < Formula
  desc "Regular expressions library forked from Oniguruma"
  homepage "https://github.com/k-takata/Onigmo"
  url "https://github.com/k-takata/Onigmo/releases/download/Onigmo-6.2.0/onigmo-6.2.0.tar.gz"
  sha256 "c648496b5339953b925ebf44b8de356feda8d3428fa07dc1db95bfe2570feb76"
  license "BSD-2-Clause"
  head "https://github.com/k-takata/Onigmo.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6da2a45f04ccd10f3d53a55f8ee740f6e34de3028cfb90034521b8d7d75062c0"
    sha256 cellar: :any,                 arm64_sequoia: "7dfc12c6ac3db48e2927137723a4d9ee1cf0b48d3188b142231b87add252e101"
    sha256 cellar: :any,                 arm64_sonoma:  "3e7750a967115b4f15803abf886f850cb8840f42c67749bb4b5c3bb96861273c"
    sha256 cellar: :any,                 arm64_ventura: "982e2aa0d17a1a598740ba22040c8a33c37fc8995b75a0b86c5016975cf2aad6"
    sha256 cellar: :any,                 sonoma:        "7fbf4f9e56dd3c2059a690e45bcc65dc822cb0af307a7786daf9c1bb76ff7af0"
    sha256 cellar: :any,                 ventura:       "aae7be640b247269995fc92160e4251c47fb3c95302f549e59b8daeebb4074fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a444a6283b28d04bf90227d5e489c4b5376ff6ac3878f685380dd9c96f879a75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f13dd8f0e389c3210abc32b970ab87259f40b37a057bc10a0cd6b4416f4b8fb"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match(/#{prefix}/, shell_output("#{bin}/onigmo-config --prefix"))
  end
end
