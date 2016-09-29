class BrewGem < Formula
  desc "Install rubygems as homebrew formulae"
  homepage "https://github.com/sportngin/brew-gem"
  url "https://github.com/sportngin/brew-gem/archive/v0.8.1.tar.gz"
  sha256 "9054ceb834b12a45c72bf4a2c082de25a7b3380ea1b36083b65a5dd992f215ed"

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
