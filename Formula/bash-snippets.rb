class BashSnippets < Formula
  desc "Collection of small bash scripts for heavy terminal users"
  homepage "https://github.com/alexanderepstein/Bash-Snippets"
  url "https://github.com/alexanderepstein/Bash-Snippets/archive/v1.23.0.tar.gz"
  sha256 "59b784e714ba34a847b6a6844ae1703f46db6f0a804c3e5f2de994bbe8ebe146"

  bottle :unneeded

  conflicts_with "cheat", :because => "Both install a `cheat` executable"

  def install
    system "./install.sh", "--prefix=#{prefix}", "all"
  end

  test do
    output = shell_output("#{bin}/weather Paramus").lines.first.chomp
    assert_equal "Weather report: Paramus", output
    output = shell_output("#{bin}/qrify This is a test")
    assert_match "████ ▄▄▄▄▄ █▀ █▀▄█ ▄▄▄▄▄ ████", output
    assert_match "Apple Inc. -- Stock Information", shell_output("#{bin}/stocks Apple")
  end
end
