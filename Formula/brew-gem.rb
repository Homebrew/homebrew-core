class BrewGem < Formula
  desc "Install rubygems as homebrew formulae"
  homepage "https://github.com/sportngin/brew-gem"
  url "https://github.com/sportngin/brew-gem/archive/v0.7.0.tar.gz"
  sha256 "34f5999fc2c0a99118e0419f89be35a6e42ad9abad99e1c13e34d9162121b541"

  head "https://github.com/sportngin/brew-gem.git"

  bottle :unneeded

  def install
    lib.install Dir["lib/*"]
    bin.install "bin/brew-gem"
  end

  test do
    system "#{bin}/brew-gem", "help"
  end
end
