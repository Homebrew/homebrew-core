class BrewNews < Formula
  desc "Software exploration tool for brew"
  homepage "https://github.com/devsli/brew-news"
  url "https://github.com/devsli/brew-news/archive/v1.0.tar.gz"
  sha256 "74d730b9b887bb2bcdd805340ebc135c28833303263d89d6e2cd907f4a11b17b"

  def install
    bin.install "brew-news"
  end

  test do
    system "#{bin}/brew-news", "-v"
  end
end
