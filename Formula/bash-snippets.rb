class BashSnippets < Formula
  desc "Collection of small bash scripts for heavy terminal users"
  homepage "https://github.com/alexanderepstein/Bash-Snippets"
  url "https://github.com/alexanderepstein/Bash-Snippets/archive/v1.22.0.tar.gz"
  sha256 "4e08e9a884db6794967518b70cd0b052ea4098c84d4e6bfa1d7d6d8dcda40f62"

  bottle :unneeded

  conflicts_with "cheat", :because => "Both install a `cheat` executable"

  def install
    system "./install.sh", "--prefix=#{prefix}", "all"
  end

  test do
    output = shell_output("#{bin}/weather Paramus").lines.first.chomp
    assert_equal "Weather report: Paramus, United States of America", output
    output = shell_output("#{bin}/qrify This is a test")
    assert_match "████ ▄▄▄▄▄ █▀ █▀▄█ ▄▄▄▄▄ ████", output
    assert_match "AAPL stock info", shell_output("#{bin}/stocks Apple")
  end
end
