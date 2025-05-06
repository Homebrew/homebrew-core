class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.185.tar.gz"
  sha256 "ba5caed7a720b9a58e2af0dd35ab9337f8808dff3f597ad4a0385817522bc396"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65dfe141d1a055cd1791fc594fa3ad9ed2004cfdc3b6ef36906ec6372395a798"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65dfe141d1a055cd1791fc594fa3ad9ed2004cfdc3b6ef36906ec6372395a798"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65dfe141d1a055cd1791fc594fa3ad9ed2004cfdc3b6ef36906ec6372395a798"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ad9507e88b31b3bde7c7f1057a352284d91e5fbd06b3751c03490cd52919ff4"
    sha256 cellar: :any_skip_relocation, ventura:       "7ad9507e88b31b3bde7c7f1057a352284d91e5fbd06b3751c03490cd52919ff4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "885d047d46b33684fa5d263b002dc6c05bb4d0ccafd606f260ca71f2b5c893f6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = shell_output("#{bin}/fabric-ai --dry-run < /dev/null 2>&1")
    assert_match "error loading .env file: unexpected character", output
  end
end
