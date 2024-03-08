class Adrs < Formula
  desc "Architectural Decision Record tool in Rust"
  homepage "https://joshrotenberg.com/adrs/"
  url "https://github.com/joshrotenberg/adrs/archive/refs/tags/v0.2.1.tar.gz"
  version "0.2.1"
  sha256 "f2f35d3373734d687104e34c9dfce0496c6610ec024c1f03e7b268362237a5b8"
  license "Apache-2.0"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "false"
  end
end
