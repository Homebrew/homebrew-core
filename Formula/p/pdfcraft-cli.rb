class PdfcraftCli < Formula
  desc "Headless PdfCraft CLI and MCP server to create, edit, inspect and fill PDFs"
  homepage "https://getartcraft.com/apps/pdfcraft"
  url "https://github.com/storytold/pdfcraft/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "72bf89e224ccb4cfbbf9f57842a04f03e4e446d90429d5a0aadd3aaf3ec94574"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/pdfcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8048ec59f6060755cee67b8b31b3411c26f66027d210b46bdd16d364d2309ab0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f01d39c1d79afdfab67d4fb95bd656cb836c30e7647878e308d4aac939a80797"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "30a3b95b426e5f2f355a8e03a73a0c7a8a736cd5ebae1bd258702b7d0d0a81c6"
    sha256 cellar: :any,                 arm64_linux:       "33d79217ccfcaa39d02c48cef1206edde1d788a1a80ff8ce61b1e4e1f2b15dca"
    sha256 cellar: :any,                 x86_64_linux:      "7e3316fad701f0256c967d23c91369a614857244d1fa7b163640c3768ffad62b"
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
