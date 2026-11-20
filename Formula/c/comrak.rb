class Comrak < Formula
  desc "CommonMark + GFM compatible Markdown parser and renderer"
  homepage "https://comrak.ee"
  url "https://github.com/kivikakk/comrak/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "bec24b69764da2f5e904503b3c27cd90720ab21e13c3ee5e09c36459ae377d27"
  license "BSD-2-Clause"
  head "https://github.com/kivikakk/comrak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b619ce90356f650cbc4d517da56c95ecef1b9bb0f907e3bf512ebc97d2553a96"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9a7221d80babb6f2e75dfe5189aa3c6c0ee59dadfd149fc90e04deecf681eeab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9b5c8e40ecc779fa44c7c428cb32abe381bf23373445e5763eecf082880f8869"
    sha256 cellar: :any,                 arm64_linux:       "f1d897041e42e991c5692aa22b9b887d0d71d40b6ecd305f432e33ad54decb68"
    sha256 cellar: :any,                 x86_64_linux:      "4e3a5c9bdfc73dd5c5eb56395bede66d4c7bb3bff89abf7c90bb49101a9f86fe"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/comrak --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello, World!

      This is a test of the **comrak** Markdown parser.
    MARKDOWN

    output = shell_output("#{bin}/comrak test.md")
    assert_match "<h1>Hello, World!</h1>", output
    assert_match "<p>This is a test of the <strong>comrak</strong> Markdown parser.</p>", output
  end
end
