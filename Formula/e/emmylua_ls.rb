class EmmyluaLs < Formula
  desc "Lua Language Server"
  homepage "https://github.com/EmmyLuaLs/emmylua-analyzer-rust"
  # The project name is `emmylua-analyzer-rust`, but it contains several crates, not all of which we install.
  url "https://github.com/EmmyLuaLs/emmylua-analyzer-rust/archive/refs/tags/0.25.1.tar.gz"
  sha256 "497b80cf970afbcced36d446a29bde2b59a86f10bbfa936d86f048450553fb0c"
  license "MIT"
  head "https://github.com/EmmyLuaLs/emmylua-analyzer-rust.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5644ab45dddfb543abc3b8674fcb3698c4acafbc391bd16f75f5d018931bccf8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bdbd76e8f73485dec66e84ea33fd23f6fbbc01766c9d1650dfcdd066bc0af50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3270802ff4a19a20363a4eb9d94b5c135b5f4a5ca4cb280feaa800a9f3103339"
    sha256 cellar: :any_skip_relocation, sonoma:        "20c36c76db4a87871473b8c179d47f4468d71f16f9e4db6803779b4dd2339e44"
    sha256 cellar: :any,                 arm64_linux:   "d63354721bdfcd17b5273a8129263a824f7235ab9365ef06c5ca3a5a48c8bd54"
    sha256 cellar: :any,                 x86_64_linux:  "70f23cb127adfc6eb42f73553c06d04e7a03b18350fa2850916f7ab5e05e3cdd"
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
