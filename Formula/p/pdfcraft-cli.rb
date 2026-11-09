class PdfcraftCli < Formula
  desc "Headless PdfCraft CLI and MCP server to create, edit, inspect and fill PDFs"
  homepage "https://getartcraft.com/apps/pdfcraft"
  url "https://github.com/storytold/pdfcraft/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "5d5461e3b35f54d0e7b4f265d8cfb7d59910401f4ff8880aadf5f8c2b4c44747"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/pdfcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bde8e54e0f5bf02dd1b8b00f30d1662c83c0cf8ce7047b6d2993de3e39b9c1ba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1be1013b84aa05962d85b2e79cecb52e81a7cf176b853cb444eaf4f037078283"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a517b40c9722a8c2b9676fdd2f9757edff7bec625a25c00fc205e46aeecae05a"
    sha256 cellar: :any,                 arm64_linux:       "a9bdc6f0f68553b3ca132126a5f181f3f29f81b84dcd4f35f6051bf839494f78"
    sha256 cellar: :any,                 x86_64_linux:      "62b818ab4e00c01dfbc914976857a5ab123ef57982beceff3177e0640b19fbc5"
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
