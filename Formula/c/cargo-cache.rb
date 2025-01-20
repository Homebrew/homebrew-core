class CargoCache < Formula
  desc "Display information on the cargo cache, plus optional cache pruning"
  homepage "https://github.com/matthiaskrgr/cargo-cache"
  url "https://github.com/matthiaskrgr/cargo-cache/archive/refs/tags/0.8.3.tar.gz"
  sha256 "d0f71214d17657a27e26aef6acf491bc9e760432a9bc15f2571338fcc24800e4"
  license any_of: ["Apache-2.0", "MIT"]

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("CARGO_HOME=#{bin} cargo cache")
    assert_match "0 installed binaries:", output
  end
end