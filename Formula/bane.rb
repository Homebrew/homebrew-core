class Bane < Formula
  desc "The magic of Old Memes, now in your command-line."
  homepage "https://github.com/ctrezevant/bane"
  url "https://github.com/ctrezevant/bane/archive/v1.0.tar.gz"
  version "1.0.0"
  sha256 "3622fad27f0cbb3cc45f100463ccb296ed3cd6448f913313fd5e113cbe9ff5d2"

  def install
    system "make"
    bin.install "build/bane"
  end

  test do
    system "#{bin}/bane"
  end
end
