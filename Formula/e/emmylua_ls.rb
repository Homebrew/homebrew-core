class EmmyluaLs < Formula
  desc "Lua Language Server"
  homepage "https://github.com/EmmyLuaLs/emmylua-analyzer-rust"
  # The project name is `emmylua-analyzer-rust`, but it contains several crates, not all of which we install.
  url "https://github.com/EmmyLuaLs/emmylua-analyzer-rust/archive/refs/tags/0.19.0.tar.gz"
  sha256 "3d2c49d1851a25bc2dd283fd73d6d3fecb14437d6d17588639a4548edcce2d49"
  license "MIT"
  head "https://github.com/EmmyLuaLs/emmylua-analyzer-rust.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ffbe1a47ab3d40e0e69b0661975f02fd968c59ca015961db4b25ed9b095c26a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9868a4735d41a47de3f3b0e4576bb6df5c52e9fc6df4bce2e54f16f2fab1d67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5566aa65b79953b73241a056d36636fd97c9239c0b9a44dfb8702390e15722b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1915e8c1d59fe1251eb1bac1bb14340919d33e36b4946874983f33049b6fc1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5af7ceee2ebe2f2a5c8cd1442af9f8ff25b769502ab771909744422d6ae5c77c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bf0b71bf8e10ac7105ddb365ac7c03c4370fd961deed93cbcd4427b4028fde0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/emmylua_ls")
    system "cargo", "install", *std_cargo_args(path: "crates/emmylua_doc_cli")
    system "cargo", "install", *std_cargo_args(path: "crates/emmylua_check")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/emmylua_ls --version")

    require "open3"

    json = <<~JSON
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

    Open3.popen3(bin/"emmylua_ls") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
