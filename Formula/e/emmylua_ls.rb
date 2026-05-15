class EmmyluaLs < Formula
  desc "Lua Language Server"
  homepage "https://github.com/EmmyLuaLs/emmylua-analyzer-rust"
  # The project name is `emmylua-analyzer-rust`, but it contains several crates, not all of which we install.
  url "https://github.com/EmmyLuaLs/emmylua-analyzer-rust/archive/refs/tags/0.23.1.tar.gz"
  sha256 "c0923591e7005e0b4cf017687e9fe0bcdbfae0ab954fb2b2c5961b6a14672856"
  license "MIT"
  head "https://github.com/EmmyLuaLs/emmylua-analyzer-rust.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc5864c695135aa178800e8984d12c2175ff9688284fd2b079442bf951a57a67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65e78667a942eddb5760e98b1ecff9d8b2aa75155ba8bded66cc84e90dc846bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7fa169bd40a4b43afbd2e17626c891c6f6f6265b603e3578d9a393a3ee5d0c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfbc3a60bd1c5d28eef0708f9763ee84cbc97453263621a25e42dd9af734290d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37f2d090376b4f96e969432c625d909d09e4355d4a80061546c4fb2b4464fbf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1e8a221ca355a6393ec9504262566a00dc4de5a664a502c903e5366393f442a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

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
