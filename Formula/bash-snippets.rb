class BashSnippets < Formula
  desc "Collection of small bash scripts for heavy terminal users"
  homepage "https://github.com/alexanderepstein/Bash-Snippets"
  url "https://github.com/alexanderepstein/Bash-Snippets/archive/v1.1.1.tar.gz"
  sha256 "d82c9dc428fd609fe1135d74daa2fe03684855e9bc062eab1d4fcd6b66a42b87"

  option "without-crypt", "Don't install crypt"
  option "without-currency", "Don't install currency"
  option "without-movies", "Don't install movies"
  option "without-stocks", "Don't install stocks"
  option "without-weather", "Don't install weather"

  def install
    snippets = %w"crypt currency movies stocks weather"

    snippets.delete("crypt") if build.without?("crypt")
    snippets.delete("currency") if build.without?("currency")
    snippets.delete("movies") if build.without?("movies")
    snippets.delete("stocks") if build.without?("stocks")
    snippets.delete("weather") if build.without?("weather")

    snippets.each do |snippet|
      bin.install "#{snippet}/#{snippet}"
    end
  end

  test do
    system "false"
  end
end
