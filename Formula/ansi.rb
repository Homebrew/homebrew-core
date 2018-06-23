class Ansi < Formula
  desc "This bash script is designed to help you colorize words and bits of text"
  homepage "https://github.com/fidian/ansi"
  url "https://github.com/fidian/ansi/archive/1.1.0.tar.gz"
  sha256 "0930acff725a505e430c68784e12731e8329998d60efcd759a7ff52e6baac959"

  def install
    bin.install "ansi"
  end

  test do
    system "#{bin}/ansi", "--help"
  end
end
