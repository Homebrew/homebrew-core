class BashSnippets < Formula
  desc "Collection of small bash scripts for heavy terminal users"
  homepage "https://github.com/alexanderepstein/Bash-Snippets"
  url "https://github.com/alexanderepstein/Bash-Snippets/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "59b784e714ba34a847b6a6844ae1703f46db6f0a804c3e5f2de994bbe8ebe146"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d9c146c0d2b5d4e6ec135939558a9a61f40f416c9087be9bcc968f09a156998"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d9c146c0d2b5d4e6ec135939558a9a61f40f416c9087be9bcc968f09a156998"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d9c146c0d2b5d4e6ec135939558a9a61f40f416c9087be9bcc968f09a156998"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd3fba704985cfdaef3cb86ca549b505e4ea7eecd3635c9acc3061f78acfa293"
    sha256 cellar: :any_skip_relocation, ventura:       "dd3fba704985cfdaef3cb86ca549b505e4ea7eecd3635c9acc3061f78acfa293"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d9c146c0d2b5d4e6ec135939558a9a61f40f416c9087be9bcc968f09a156998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d9c146c0d2b5d4e6ec135939558a9a61f40f416c9087be9bcc968f09a156998"
  end

  conflicts_with "cheat", because: "both install a `cheat` executable"
  conflicts_with "expect", because: "both install `weather` binaries"
  conflicts_with "pwned", because: "both install `pwned` binaries"
  conflicts_with "todoman", because: "both install `todo` binaries"

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
