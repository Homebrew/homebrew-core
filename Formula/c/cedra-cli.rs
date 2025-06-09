class CedraCli < Formula
  desc "CLI tool for Cedra Labs"
  homepage "https://cedra.network/"
  url "https://github.com/cedra-labs/cedra/archive/refs/tags/cedra-cli-v7.3.1.tar.gz"
  sha256 "9044008e39f4c10f8a4cfa76783c917914c547c4fb3744a291bfaedcdf3f839e"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "cedra", shell_output("#{bin}/cedra --help")
  end
end
