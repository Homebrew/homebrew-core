class BrewGem < Formula
  desc "Install RubyGems as Homebrew formulae"
  homepage "https://github.com/sportngin/brew-gem"
  url "https://github.com/sportngin/brew-gem/archive/v0.8.4.tar.gz"
  sha256 "86c33cc592f5e0270ac50fda9a54df596c00fbe1ff0ef718b64d014905dae0de"

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
