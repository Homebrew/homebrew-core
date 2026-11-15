class BaconLs < Formula
  desc "Rust diagnostic provider based on Bacon"
  homepage "https://github.com/crisidev/bacon-ls"
  url "https://github.com/crisidev/bacon-ls/archive/refs/tags/0.32.0.tar.gz"
  sha256 "45c0ff8fecb33ce96c7e464566d338e500e37673a82bb3c80bb96fcea4c502fd"
  license "MIT"
  head "https://github.com/crisidev/bacon-ls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1aeb120945ca71a3d73b92a6475521b7eadd2ed3f3355335012084b18f989886"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "34a5cfa6615f60c999083bd9f42455271340513cb7014d2ed0a56d0aec369617"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "63f5a8fec139aa8a5c94945cd48ce33eb3a15ef5704badc6890a1e9e86751123"
    sha256 cellar: :any,                 arm64_linux:       "10df2676d947252767bada254012689862e9f1c7bbe80ea2222d3deb6d0fdf26"
    sha256 cellar: :any,                 x86_64_linux:      "c5aa83edc535b0d5f2022456d63eb320d6c53ba1e2f26b359aa32f220aa3b502"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
