class PdfcraftCli < Formula
  desc "Headless PdfCraft CLI and MCP server to create, edit, inspect and fill PDFs"
  homepage "https://getartcraft.com/apps/pdfcraft"
  url "https://github.com/storytold/pdfcraft/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "51f6c4ff4a71809f00a93356d074816e89afe0dfd4f8fcc6be42e59f63c78365"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/pdfcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "11737c11c9a2ef8e86fd57081dfaeaee0337551f6f3fb150d71444729db46209"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5c490cf17cf7d364f0bacb623e991976ea58b876f84f4511eea1622b2c87049b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7bdaa6da71fe12876d866035fe22c2c7040ff6a030af52e4faaf7d7dba629488"
    sha256 cellar: :any,                 arm64_linux:       "4497d230dc7e6fd092d6ade3119e659f966ab23e954b12950ad691b46019cf05"
    sha256 cellar: :any,                 x86_64_linux:      "ad21edec5d92b694fa394caf75b1add4a44fc57d6300bc054b5be21d1eb0c36f"
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
