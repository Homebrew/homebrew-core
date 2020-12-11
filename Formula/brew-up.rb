class BrewUp < Formula
  desc "Interactive upgrade outdated casks and outdated"
  homepage "https://github.com/mkanako/brew-up"
  url "https://github.com/mkanako/brew-up/archive/v1.0.0.tar.gz"
  sha256 "b3f313304d6e45007953824fff167f5cc571c2d4f641ea3e6f15b93b60feadf7"
  license "MIT"

  bottle :unneeded

  def install
    bin.install "brew-up.sh"
    bin.install_symlink "brew-up.sh" => "brew-up"
  end

  test do
    assert_match "usage: brew-up [-s]", shell_output("#{bin}/brew-up -h")
  end
end
