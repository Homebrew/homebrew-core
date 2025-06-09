class CedraCli < Formula
  desc "CLI tool for Cedra Labs"
  homepage "https://cedra.network/"
  url "https://github.com/cedra-labs/cedra/archive/refs/tags/cedra-cli-v7.3.1.tar.gz"
  sha256 "49a50bafaf983e0ea85fdab1364012a4200b1198f7b0e087cf7c88e8b15722e0"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "cedra", shell_output("#{bin}/cedra --help")
  end
end
