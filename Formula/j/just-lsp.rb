class JustLsp < Formula
  desc "Language server for just"
  homepage "https://github.com/terror/just-lsp"
  url "https://github.com/terror/just-lsp/archive/refs/tags/0.5.0.tar.gz"
  sha256 "ceb3a2ec7c8d0c1cae4dd8e542303892e679b70a85393dc99766654e77207df2"
  license "CC0-1.0"
  head "https://github.com/terror/just-lsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "143fac27a3b2347be9fb9d5d41f650c481c9b4edfc50258589e352ee5591ceee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8de14740e97d64dba248f5246297b854d6d27cdbb42c1eeab6916d681206bfad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74a10cc9851ce902cbccf1cfa5bfe1f4b6b2d67e3c5ff7e21e2c1ca75eabad7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6fa86a378cfeb024ff163fd31fadc2f82f1c6de6e5e782ff2dc19e8b91758d0"
    sha256 cellar: :any,                 arm64_linux:   "6265eb256e7638233e8f3b80d6fcc496b9491e1ecdea2c803adbfa801ae83468"
    sha256 cellar: :any,                 x86_64_linux:  "241ede8da3bcd23dfcbb2e95c5197eec84d479a54b666a92cf018e594d9bfcd8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/just-lsp --version")

    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "processId": 88075,
          "rootUri": null,
          "capabilities": {},
          "trace": "verbose",
          "workspaceFolders": null
        }
      }
    JSON

    Open3.popen3(bin/"just-lsp") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
