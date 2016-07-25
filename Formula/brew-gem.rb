class BrewGem < Formula
  desc "Install rubygems as homebrew formulae"
  homepage "https://github.com/sportngin/brew-gem"
  url "https://github.com/sportngin/brew-gem/archive/v0.7.3.tar.gz"
  sha256 "4db0087f7c9e418589bd76f2e83db0b577d51b999336e4fe1b1c0b3b17181bac"

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
