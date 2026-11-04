class PdfcraftCli < Formula
  desc "Headless PdfCraft CLI and MCP server to create, edit, inspect and fill PDFs"
  homepage "https://getartcraft.com/apps/pdfcraft"
  url "https://github.com/storytold/pdfcraft/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "2f304a979eab593c9b01488a98b9f75a9b9f2e497b1c9cab368d49b6671e2038"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/pdfcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7bf2a5dea40aee32a0e4e19a2e5a4cf682d560b0ac4ea77802863524cde429b4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bc1b77999bf43efcb556f17a39e50487c9465683b086f29c5ea69770dd3e0a3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2b9ee965c7322eca103fd3330a44dd5b8b4d5b4cddf817bc67d41a116ca947e9"
    sha256 cellar: :any,                 arm64_linux:       "f9a6d5707692c6519c53a8171094981cdcd9dcfe930918516e7b33ccd6669894"
    sha256 cellar: :any,                 x86_64_linux:      "7e0e966725c0e8c358c847bd9da4ccf2180519404d5e588d7419027f0920e1ca"
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
