class BashSnippets < Formula
  desc "Collection of small bash scripts for heavy terminal users"
  homepage "https://github.com/alexanderepstein/Bash-Snippets"
  url "https://github.com/alexanderepstein/Bash-Snippets/archive/v1.22.1.tar.gz"
  sha256 "72a4d11ddd2e8e1c48fcee816cd43a34e34348102474c6b76c9cb31d1e95c8eb"

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
