class BaconLs < Formula
  desc "Rust diagnostic provider based on Bacon"
  homepage "https://github.com/crisidev/bacon-ls"
  url "https://github.com/crisidev/bacon-ls/archive/refs/tags/0.31.0.tar.gz"
  sha256 "dce1cd99b8a4ad8337338997477437917126bbccf10e7c3161dd538c14c746fd"
  license "MIT"
  head "https://github.com/crisidev/bacon-ls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "214426c64353514d4b8bbbfb5c2188e86654040dc4942eee69178de6aabbe3b4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a67135f9134a9f78d39fc8af1111e5c57581e9e9f71be6a5a7c1c9a6d7af3c01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cd7b4a52c2d878c76f1f8d6cb3008a5396ce8ec68524cb490e385a770c946b98"
    sha256 cellar: :any,                 arm64_linux:       "1efa5d707bc349c81fd9928e731afc02441b0c659d0eda06dd602686ac7b403c"
    sha256 cellar: :any,                 x86_64_linux:      "9767b471b4a8d1ead9255e5d65c4b2aab67a9f335a19fb80553fd330a730010d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "open3"

    assert_match version.to_s, shell_output("#{bin}/bacon-ls --version")

    init_json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin/"bacon-ls") do |stdin, stdout, _|
      stdin.write "Content-Length: #{init_json.bytesize}\r\n\r\n#{init_json}"
      stdin.close

      assert_match(/^Content-Length: \d+/i, stdout.read)
    end
  end
end
