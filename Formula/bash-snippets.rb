class BashSnippets < Formula
  desc "Collection of small bash scripts for heavy terminal users"
  homepage "https://github.com/alexanderepstein/Bash-Snippets"
  url "https://github.com/alexanderepstein/Bash-Snippets/archive/v1.20.0.tar.gz"
  sha256 "cef0ec02aa14b7cc130fb58ed901ad285a3ab6ce400cd85316e864e17a098202"

  bottle :unneeded

  option "with-cheat", "Install cheat"
  option "with-cloudup", "Install cloudup"
  option "with-crypt", "Install crypt"
  option "with-cryptocurrency", "Install cryptocurrency"
  option "with-currency", "Install currency"
  option "with-geo", "Install geo"
  option "with-lyrics", "Install lyrics"
  option "with-movies", "Install movies"
  option "with-newton", "Install newton"
  option "with-qrify", "Install qrify"
  option "with-short", "Install short"
  option "with-siteciphers", "Install siteciphers"
  option "with-stocks", "Install stocks"
  option "with-taste", "Install taste"
  option "with-todo", "Install todo"
  option "with-transfer", "Install transfer"
  option "with-weather", "Install weather"
  option "with-ytview", "Install ytview"
  option "without-all-tools", "Do not install all available snippets"

  if build.with?("all-tools") || build.with?("cheat")
    conflicts_with "cheat", :because => "Both install a `cheat` executable"
  end

  def install
    if build.with? "all-tools"
      system "./install.sh", "--prefix=#{prefix}", "all"
    else
      args = []
      %w[cheat cloudup crypt cryptocurrency currency geo lyrics movies newton qrify
         short siteciphers stocks taste todo transfer weather ytview].each do |tool|
        args << tool if build.with? tool
      end
      system "./install.sh", "--prefix=#{prefix}", *args
    end
  end

  test do
    if build.with?("all-tools") || build.with?("weather")
      output = shell_output("#{bin}/weather Paramus").lines.first
      assert_equal "Weather report: Paramus, United States of America", output.chomp
    end
    if build.with?("all-tools") || build.with?("qrify")
      output = shell_output("#{bin}/qrify This is a test")
      assert_match "████ ▄▄▄▄▄ █▀ █▀▄█ ▄▄▄▄▄ ████", output
    end
    if build.with?("all-tools") || build.with?("stocks")
      assert_match "AAPL stock info", shell_output("#{bin}/stocks Apple")
    end
  end
end
