class BashSnippets < Formula
  desc "Collection of small bash scripts for heavy terminal users"
  homepage "https://github.com/alexanderepstein/Bash-Snippets"
  url "https://github.com/alexanderepstein/Bash-Snippets/archive/v1.15.1.tar.gz"
  sha256 "ecc771d8d8486229309bdcaef330492ce37fb827e6ce276f251380db4a63930b"

  bottle :unneeded

  def install
    system "./install.sh", "--prefix=#{prefix}", "all"
  end

  test do
    output = shell_output("#{bin}/weather Paramus").lines.first
    assert_equal "Weather report: Paramus, United States of America", output.chomp
    output = shell_output("#{bin}/qrify This is a test")
    assert_match "████ ▄▄▄▄▄ █▀ █▀▄█ ▄▄▄▄▄ ████", output
    assert_match "AAPL stock info", shell_output("#{bin}/stocks Apple")
  end
end
