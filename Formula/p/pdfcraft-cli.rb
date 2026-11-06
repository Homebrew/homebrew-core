class PdfcraftCli < Formula
  desc "Headless PdfCraft CLI and MCP server to create, edit, inspect and fill PDFs"
  homepage "https://getartcraft.com/apps/pdfcraft"
  url "https://github.com/storytold/pdfcraft/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "90baad3d8f54ae289bc12197c075134c8ede28f074c57d92e0f1f08354ceea70"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/pdfcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c61a92e2bb142f482e687fccb153843b3821c745a193a3b35523460ee318e24e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "03651cf9b594a54fe6277a5def734638a93b8d0421bf80586ffff66cacc0ec60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fd5fc42982f0257318e32b6aac5742049b3c055a9e3f288d1a2731e38490301e"
    sha256 cellar: :any,                 arm64_linux:       "da93bddf1c96c6ec1e5b2cf0d05e86b3fef5df5a5374406929ba0aa09e84bce7"
    sha256 cellar: :any,                 x86_64_linux:      "c295573dd8cdcfc497cc38d8f0353bafb620baaf3dd009a7ec2fec0e55b0b053"
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
