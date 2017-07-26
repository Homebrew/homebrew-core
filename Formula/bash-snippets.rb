class BashSnippets < Formula
  desc "Collection of small bash scripts for heavy terminal users"
  homepage "https://github.com/alexanderepstein/Bash-Snippets"
  url "https://github.com/alexanderepstein/Bash-Snippets/archive/v1.15.0.tar.gz"
  sha256 "314e428aafcc4a02db57768a8fa65a384789af64339a919e73cba76a224a3caf"

  bottle :unneeded

  option "without-cheat", "Don't install cheat"
  option "without-cloudup", "Don't install cloudup"
  option "without-crypt", "Don't install crypt"
  option "without-currency", "Don't install currency"
  option "without-geo", "Don't install geo"
  option "without-movies", "Don't install movies"
  option "without-short", "Don't install short"
  option "without-siteciphers", "Don't install siteciphers"
  option "without-stocks", "Don't install stocks"
  option "without-taste", "Don't install taste"
  option "without-todo", "Don't install todo"
  option "without-qrify", "Don't install qrify"
  option "without-weather", "Don't install weather"
  option "without-ytview", "Don't install ytview"

  def install
    snippets = %w[cheat cloudup crypt currency geo movies short siteciphers stocks taste todo weather qrify ytview]

    snippets.delete("cheat") if build.without?("cheat")
    snippets.delete("crypt") if build.without?("crypt")
    snippets.delete("currency") if build.without?("currency")
    snippets.delete("geo") if build.without?("geo")
    snippets.delete("movies") if build.without?("movies")
    snippets.delete("short") if build.without?("short")
    snippets.delete("siteciphers") if build.without?("siteciphers")
    snippets.delete("stocks") if build.without?("stocks")
    snippets.delete("taste") if build.without?("taste")
    snippets.delete("todo") if build.without?("todo")
    snippets.delete("qrify") if build.without?("qrify")
    snippets.delete("weather") if build.without?("weather")
    snippets.delete("ytview") if build.without?("ytview")

    snippets.each do |snippet|
      bin.install "#{snippet}/#{snippet}"
    end

    man1.install "bash-snippets.1"
  end

  test do
    system "#{bin}/crypt", "-h"
  end
end
