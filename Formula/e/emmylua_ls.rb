class EmmyluaLs < Formula
  desc "Lua Language Server"
  homepage "https://github.com/EmmyLuaLs/emmylua-analyzer-rust"
  # The project name is `emmylua-analyzer-rust`, but it contains several crates, not all of which we install.
  url "https://github.com/EmmyLuaLs/emmylua-analyzer-rust/archive/refs/tags/0.21.0.tar.gz"
  sha256 "5df0f7894b8b17ab7773625c0f2ba339aabc459995d530bedde53c3499d9d179"
  license "MIT"
  head "https://github.com/EmmyLuaLs/emmylua-analyzer-rust.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2087623c113e2654a3a78257003956614af035e0872fab04f4e6e4d7dd34bdb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22ac2cee9dc44f153801b024b60b99fa3fe5fa030d936693646c7c89b65a5016"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9310ea7fb9f9426edea3b235d4a098429213bd6e1d4d4d48a7db68251ebbde8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b18590f8033820a364e89c44eb99559dc65d936d7db3e41483dcf4841d1819cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d64c4c7c689c4878b7daf7f516a4b369d3aa1d03500b33df1c234d636799695e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "305409833d1e66665f871e0f6e1bba327a0a5238b410bcedb60de4c2075ec785"
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
