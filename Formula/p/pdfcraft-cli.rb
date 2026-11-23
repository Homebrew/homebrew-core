class PdfcraftCli < Formula
  desc "Headless PdfCraft CLI and MCP server to create, edit, inspect and fill PDFs"
  homepage "https://getartcraft.com/apps/pdfcraft"
  url "https://github.com/storytold/pdfcraft/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "e9165e846d61fdd2fcc5f53c587178750b791f4b0fa6d57212b7e0adab20be7f"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/pdfcraft.git", branch: "main"

  bottle do
    manifest_sha256 "2e113773c6abb7f3e9d6d98e0c2677496bb1338b99f45f245f5e92fae92cd364"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "10611a63e50aaf96cf09fb70de3e96c30e5f69610f38cb0c8951b44bdfa6251c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "463152abf834fc15c8dd3bb072174dbedc0d56c0c4eedd442a3ae13d1eaffed4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d5eac735c309fd625322a03d48a858e7eb7fbd17c12699fb0146fd83ba604374"
    sha256 cellar: :any,                 arm64_linux:       "7ac0ab52ee3857a680435c34bf42afbb2ec9d89b56410d8895400da868f9c4b8"
    sha256 cellar: :any,                 x86_64_linux:      "a6225b3adaa4a022a3c34733e7c9233afc04e650c20d3fa35d8aed7f75299eb0"
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
