class Mdr < Formula
  desc "Make diffs readable"
  homepage "https://github.com/halffullheart/mdr"
  url "https://github.com/halffullheart/mdr/archive/v1.0.1.tar.gz"
  sha256 "103d52c47133a43cc7a6cb8a21bfabe2d6e35e222d5b675bc0c868699a127c67"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c42ad80e535b77f569ab48ece2fc3a648e71f67cd9dca68659985b7478a6f876"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4faacaab5dd0acefaee74a73abaa093d69bd6caefb764375d0565f20605b81c6"
    sha256 cellar: :any_skip_relocation, monterey:       "198d9654af44050d6ead21208b8057b861c804470fdc1cd452f14f825f9b901d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4540fb82156ec6317ae37ffc8889b1e11d6a0b6327528e53bca505057632c31f"
    sha256 cellar: :any_skip_relocation, catalina:       "9da0233ef931bc31dff9356e3298f5c838fbbe3422d64cbfa1e3751bd09545d0"
    sha256 cellar: :any_skip_relocation, mojave:         "6dec04545f16f59af2b9b2397d4ebf65c204c827fef52cb20ef81c12d2273cda"
    sha256 cellar: :any_skip_relocation, high_sierra:    "58d0fa82a0e6291d934bbc3f12f586fbb35282f9d15db017126e042f209dd664"
    sha256 cellar: :any_skip_relocation, sierra:         "ef68c4389ee92beeb6c04e1859f398d108ffcce03fe692dd5776f7e12d776672"
    sha256 cellar: :any_skip_relocation, el_capitan:     "0b522120151f1116ae7e681ff2fb129ecd26486202ca753d6b1de902f6f29334"
    sha256 cellar: :any_skip_relocation, yosemite:       "7048e71ef8f9a1d5c1712dce6cb33df08029038d771789021a1b8bc1e5f4ad10"
  end

  deprecate! date: "2022-05-14", because: :unmaintained

  def install
    system "rake"
    libexec.install Dir["*"]
    bin.install_symlink libexec/"build/dev/mdr"
  end

  test do
    system "#{bin}/mdr", "-h"
  end
end
