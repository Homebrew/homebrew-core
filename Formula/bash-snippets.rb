class BashSnippets < Formula
  desc "Collection of small bash scripts for heavy terminal users"
  homepage "https://github.com/alexanderepstein/Bash-Snippets"
  url "https://github.com/alexanderepstein/Bash-Snippets/archive/v1.16.0.tar.gz"
  sha256 "19a029a204f16bd4db30cf7fa32aa6953dd10dcb996138b9bc65c01612afaac7"

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
