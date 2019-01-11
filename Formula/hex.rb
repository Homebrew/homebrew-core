class Hex < Formula
  desc "Futuristic take on hexdump, made in Rust"
  homepage "https://github.com/sitkevij/hex"
  url "https://github.com/sitkevij/hex/archive/v0.1.3.tar.gz"
  sha256 "7c5397b1f435d2e3b5280cf6186ea8fcc44690fda812e303b6b51b6bbececc5e"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/hex")
    assert_match "hex", output
  end
end
