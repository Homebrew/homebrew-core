class Crunch < Formula
  desc "Wordlist generator"
  homepage "https://sourceforge.net/projects/crunch-wordlist/"
  url "https://downloads.sourceforge.net/project/crunch-wordlist/crunch-wordlist/crunch-3.6.tgz"
  sha256 "6a8f6c3c7410cc1930e6854d1dadc6691bfef138760509b33722ff2de133fe55"
  license "GPL-2.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d449463edb9406d92410104b8302202c4aebd190cc181d8fea3e4fea2e8ef0c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "902a5ca993d69c4678b0243e7ba59b08c85c85091fdecea036ec25d863da4388"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05a40b6394c4668a8d19480118b9a19ae1341f16608edce7190fc75072075b42"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7012aebe6b421760ccec1550bb6ca1684f5808d8b7f4aa4b31a939f4a50fcf58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7f96f0cb4350722c3b04aca1d7d0d9a94b9084649888216d1ec4f089809fe8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfc7c5b56963d28a58c64a2a28d0c19b61dfce141b83c9facaad0d8d606949b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e90eb0b16dc80dc8105256d758e8e561604795087b3f596ef3296bc1c01cb6f"
    sha256 cellar: :any_skip_relocation, ventura:        "21786261bea2b66d97b4f2b089929175cf79690491b1d45768900cb9384f69b0"
    sha256 cellar: :any_skip_relocation, monterey:       "7797dae15adc8701e4d93c3a0455adb8796aca9f7e366bfa12448ce9aeac7153"
    sha256 cellar: :any_skip_relocation, big_sur:        "9cd9d5ae5afb6b6223e720b99d30990f1884cd8ed4e0b5654a9ab2d72cc4d132"
    sha256 cellar: :any_skip_relocation, catalina:       "67570938790b20aaabcb31c8ac86d4356702b87ce2ae8ea01d19553f531397a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "abf2c62b42c660eeb58ac32c84c77ee4f425cef5b69a4eeedc2e00cea490a001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2da41fe3124d8d6fbfd6df0fa1eefd803b2fee839332cdce61b9c8a1e15e977d"
  end

  def install
    system "make", "CC=#{ENV.cc}", "LFS=-D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"

    bin.install "crunch"
    man1.install "crunch.1"
    share.install Dir["*.lst"]
  end

  test do
    system bin/"crunch", "-v"
  end
end
