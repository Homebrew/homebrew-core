class Adrs < Formula
  desc "Architectural Decision Record tool in Rust"
  homepage "https://joshrotenberg.com/adrs/"
  url "https://github.com/joshrotenberg/adrs/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "6e22047dc47ce25664d4fa271dd0bc8e93f595a3a9c63e24d39bab1e428a23c1"
  license "Apache-2.0"

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    file = "0001-record-architecture-decisions.md"
    assert_match file, shell_output("#{bin}/adrs init")
    assert_match file, shell_output("#{bin}/adrs list")
  end
end
