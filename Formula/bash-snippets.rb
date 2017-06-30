class BashSnippets < Formula
  desc "Collection of small bash scripts for heavy terminal users"
  homepage "https://github.com/alexanderepstein/Bash-Snippets"
  url "https://github.com/alexanderepstein/Bash-Snippets/archive/v1.5.0.tar.gz"
  sha256 "4b96af15bdb34e6b48ec38f95bd0a68b0315776bf7e14c56011d5f27876ec520"

  option "without-crypt", "Don't install crypt"
  option "without-currency", "Don't install currency"
  option "without-movies", "Don't install movies"
  option "without-short", "Don't install short"
  option "without-stocks", "Don't install stocks"
  option "without-taste", "Don't install taste"
  option "without-weather", "Don't install weather"

  def install
    snippets = %w[crypt currency movies short stocks taste weather]

    snippets.delete("crypt") if build.without?("crypt")
    snippets.delete("currency") if build.without?("currency")
    snippets.delete("movies") if build.without?("movies")
    snippets.delete("short") if build.without?("short")
    snippets.delete("stocks") if build.without?("stocks")
    snippets.delete("taste") if build.without?("taste")
    snippets.delete("weather") if build.without?("weather")

    snippets.each do |snippet|
      bin.install "#{snippet}/#{snippet}"
    end
  end

  test do
    system "#{bin}/crypt", "-h"
  end
end
