class PdfcraftCli < Formula
  desc "Headless PdfCraft CLI and MCP server to create, edit, inspect and fill PDFs"
  homepage "https://getartcraft.com/apps/pdfcraft"
  url "https://github.com/storytold/pdfcraft/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "2f304a979eab593c9b01488a98b9f75a9b9f2e497b1c9cab368d49b6671e2038"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/pdfcraft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f36189b4345520e76fc51743669f5b76f2714570fa3cbf6e049bb26311cace43"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6c19ce8666e96966e6f345b29e0a0ef5d006f40f284dbbfcd90280021b7953ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3861b835a701914c81904ba7ebcf86510dbd793b8e7ba33d00db339e72d71898"
    sha256 cellar: :any,                 arm64_linux:       "4b0266ff8582a4b7ee9d09f9e59014e9bea9eec998550f23a2a843e480ff1444"
    sha256 cellar: :any,                 x86_64_linux:      "09a469fb5c3b4cfc088f395d9d8cdf68c3b8249afb3a3d86559b2f2fbd67724e"
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
