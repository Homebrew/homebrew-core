class BashSnippets < Formula
  desc "Collection of small bash scripts for heavy terminal users"
  homepage "https://github.com/alexanderepstein/Bash-Snippets"
  url "https://github.com/alexanderepstein/Bash-Snippets/archive/v1.23.0.tar.gz"
  sha256 "59b784e714ba34a847b6a6844ae1703f46db6f0a804c3e5f2de994bbe8ebe146"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e38f6d39c157dcf604f1ac774a16afe66472de96ebf612a7f409689a7074282"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e38f6d39c157dcf604f1ac774a16afe66472de96ebf612a7f409689a7074282"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e38f6d39c157dcf604f1ac774a16afe66472de96ebf612a7f409689a7074282"
    sha256 cellar: :any_skip_relocation, ventura:        "c2a441dc6d5b21408f49f4869b00919354392682b3ef7eef2f908ab2f638dd8a"
    sha256 cellar: :any_skip_relocation, monterey:       "c2a441dc6d5b21408f49f4869b00919354392682b3ef7eef2f908ab2f638dd8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2a441dc6d5b21408f49f4869b00919354392682b3ef7eef2f908ab2f638dd8a"
    sha256 cellar: :any_skip_relocation, catalina:       "c2a441dc6d5b21408f49f4869b00919354392682b3ef7eef2f908ab2f638dd8a"
    sha256 cellar: :any_skip_relocation, mojave:         "c2a441dc6d5b21408f49f4869b00919354392682b3ef7eef2f908ab2f638dd8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e38f6d39c157dcf604f1ac774a16afe66472de96ebf612a7f409689a7074282"
  end

  conflicts_with "cheat", because: "both install a `cheat` executable"

  def install
    system "./install.sh", "--prefix=#{prefix}", "all"
  end

  test do
    output = shell_output("#{bin}/weather Paramus").lines.first.chomp
    assert_equal "Weather report: Paramus", output
    output = shell_output("#{bin}/qrify This is a test")
    assert_match "████ ▄▄▄▄▄ █▀ █▀▄█ ▄▄▄▄▄ ████", output
  end
end
