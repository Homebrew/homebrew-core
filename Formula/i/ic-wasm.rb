class IcWasm < Formula
  desc "CLI tool for performing Wasm transformations specific to ICP canisters"
  homepage "https://github.com/dfinity/ic-wasm"
  url "https://github.com/dfinity/ic-wasm/archive/refs/tags/0.9.11.tar.gz"
  sha256 "579e8085c33b7cf37ed2ddc3b9a34dca5dca083201f7648c5d636bab80f75258"
  license "Apache-2.0"
  head "https://github.com/dfinity/ic-wasm.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end
end
