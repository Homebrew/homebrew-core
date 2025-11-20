class EmmyluaLs < Formula
  desc "Lua Language Server"
  homepage "https://github.com/EmmyLuaLs/emmylua-analyzer-rust"
  # The project name is `emmylua-analyzer-rust`, but it contains several crates, not all of which we install.
  url "https://github.com/EmmyLuaLs/emmylua-analyzer-rust/archive/refs/tags/0.17.0.tar.gz"
  sha256 "90c92d2b5d0fd0ef03eb775d677bb24ca76ac52be0d91f8b3fead359ae422655"
  license "MIT"
  head "https://github.com/EmmyLuaLs/emmylua-analyzer-rust.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ea529c7d14e0f96150656099ca11a2f9618eb96f6174fde72dfb846f29ca288"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fc740b49afb8f512f79d726ebc5e8c107aa6da3f2ec9fe35724077d5f1fa31b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b180e4d36e92d73920136c53f955cebe680a32f207c02c561548b2fca5f794a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c40a2d2b818bb4a54829450fa2dc7957914877bf490bc93282ba353c0b027f17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c111e537d85bc7b2cde2ac8a2ea4550a932a3abe49737cf437d81217c34dda72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7bb79399265cf784cbafc689bac01a172812214f5f69517476f80f84eaba07e"
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
