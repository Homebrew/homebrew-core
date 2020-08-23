class BrewGem < Formula
  desc "Install RubyGems as Homebrew formulae"
  homepage "https://github.com/sportngin/brew-gem"
  url "https://github.com/sportngin/brew-gem/archive/v1.0.0.tar.gz"
  sha256 "bc321722746e82243be50bc999d02f3d0754d40e7e40552ed2d61103191c82cf"
  license "MIT"
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
