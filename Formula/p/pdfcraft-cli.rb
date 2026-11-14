class PdfcraftCli < Formula
  desc "Headless PdfCraft CLI and MCP server to create, edit, inspect and fill PDFs"
  homepage "https://getartcraft.com/apps/pdfcraft"
  url "https://github.com/storytold/pdfcraft/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "d6cb5a437aa531fe3ae91250e2b6aa52cf4208cc521c17fc30aeccc917c0e9f5"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/pdfcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "86fd44faf603854604a37e4154ddb4faa69879883800fe901dd2c4b59f2f1a80"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3f1e4fdd26db0b589fa83830ca32396143762566185740b60a2bd4059289a663"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a686d7556d2eba6cdc6b55dc8951ec601d5d08685a4113ab2ff24e7e749ca714"
    sha256 cellar: :any,                 arm64_linux:       "e7da7562b7f57f3a886a4883c4d57ff34c821491c7e7a9871792846f2d7d2a26"
    sha256 cellar: :any,                 x86_64_linux:      "f65a963ebf096eb9f9717828f14c4b3fa37ce15970f57d4643ef8185096daebd"
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
