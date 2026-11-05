class PdfcraftCli < Formula
  desc "Headless PdfCraft CLI and MCP server to create, edit, inspect and fill PDFs"
  homepage "https://getartcraft.com/apps/pdfcraft"
  url "https://github.com/storytold/pdfcraft/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "59c862360ac738456ae12dafc2bf0b479bfae798f1115a6b6ff17661e3fcadb1"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/pdfcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f06a00cdebb249a95e3a5fd93768f6bcee8862035de271b91bae282c656818b5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c0aa7de6f3efbceea3695553a49a0686520c362584d6894789d4f8cec290b957"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1e274389755e8ab0c49b46291ebfa9c394c331297c1d1787e1e7fbe51ad44ca6"
    sha256 cellar: :any,                 arm64_linux:       "ea2c0f408f618e7eeef436b6183dc3296c0d4b8ce0b4c9d63371d536db046f27"
    sha256 cellar: :any,                 x86_64_linux:      "47e837a55fd0dff85771f892ee41cec4f074388a5adee373e580fa50009b0306"
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
