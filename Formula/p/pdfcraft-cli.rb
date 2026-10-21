class PdfcraftCli < Formula
  desc "Headless PdfCraft CLI and MCP server to create, edit, inspect and fill PDFs"
  homepage "https://getartcraft.com/apps/pdfcraft"
  url "https://github.com/storytold/pdfcraft/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "38476e8448e0941d8e243ee7413ad410bde54085140a24733d211ff1b6117b2e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/pdfcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "be7c35f0e39ccb9f09966bfcf48f1dd3c1e5bda85d77da53cdec8e592900ac1e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5c42b0f72ed857758e45f56fa9e19f33adec0303ab42d6542526d3e846c16fe2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "61629bad2ce33126c7b442d90a230d073d219d77cc1b96b0983d6b8a40f93ce7"
    sha256 cellar: :any,                 arm64_linux:       "ea26dbfe2ab95cfb0d8cea70991926fca47d69ed0477744a6ce8f06873ff988d"
    sha256 cellar: :any,                 x86_64_linux:      "fa44617e4ef33e77c45782428447996a807db62ee9998308e4004c94b84d7391"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/pdfcraft-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pdfcraft-cli --version")

    pdf = test_fixtures("test.pdf")
    system bin/"pdfcraft-cli", "edit", pdf, "--rotate", "1:90",
           "--title", "Homebrew Test", "--out", "out.pdf"

    info = JSON.parse(shell_output("#{bin}/pdfcraft-cli info out.pdf"))
    assert_equal 1, info["pages"]
    assert_equal [800.0, 500.0], info["first_page_pt"]
    assert_equal "Homebrew Test", info["title"]
  end
end
