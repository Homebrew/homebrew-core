class PdfcraftCli < Formula
  desc "Headless PdfCraft CLI and MCP server to create, edit, inspect and fill PDFs"
  homepage "https://getartcraft.com/apps/pdfcraft"
  url "https://github.com/storytold/pdfcraft/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "51f6c4ff4a71809f00a93356d074816e89afe0dfd4f8fcc6be42e59f63c78365"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/pdfcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "026fb627f3d83923d721b6b9777977c51b39eb95438d0b1d78403388e46092fe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8b256dec8849542fa455d9ff6ac3145e687b4d3fc79942dab9b31c7878a2c98d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b64892ef1bd4a2db7e0d68a6d0037c9dcb349f803503786305d3bd43104696b0"
    sha256 cellar: :any,                 arm64_linux:       "4fc9020631b53db9ae5d479aef673bdf0ee7c562c9b3c93fb151ec23780bd8bd"
    sha256 cellar: :any,                 x86_64_linux:      "a3cc40045d1212219f68c7ad78512dbe25373cc9dbc4edfa64189eef1b9fffca"
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
