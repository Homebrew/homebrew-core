class EmmyluaLs < Formula
  desc "Lua Language Server"
  homepage "https://github.com/EmmyLuaLs/emmylua-analyzer-rust"
  # The project name is `emmylua-analyzer-rust`, but it contains several crates, not all of which we install.
  url "https://github.com/EmmyLuaLs/emmylua-analyzer-rust/archive/refs/tags/0.14.0.tar.gz"
  sha256 "4e7da3f3904ba43a51f123ee5149194e1a42b644ab05feb191444cb8b818388d"
  license "MIT"
  head "https://github.com/EmmyLuaLs/emmylua-analyzer-rust.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ada9304206fdf98bf9ee8b8c3d09c288219799223f61d376cc082937ced1d0b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ad60b63c3e0b1f33dfe3210f60c19535c86abf5a23b5b27f4dfcf33bbc6efe7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8129decdd48a4fb7e42aa8c3a112d361d1cb2c4f7c850f20a6a2bc95ddf0ab6e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c361b3371b96da50638c97eeb1d6375f12d6f2bcb0de826b9dd935d1e4a0f1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ec8dafb5d99f85ea922cb0f9a2496cf4d500caaf9a2c83c360adeb17a828213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b0b7bf93ab7cf451014c9bcdba717bf1c16765c95bc7fd739d4edacc0ac3b32"
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
