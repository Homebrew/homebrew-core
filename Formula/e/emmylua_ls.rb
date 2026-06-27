class EmmyluaLs < Formula
  desc "Lua Language Server"
  homepage "https://github.com/EmmyLuaLs/emmylua-analyzer-rust"
  # The project name is `emmylua-analyzer-rust`, but it contains several crates, not all of which we install.
  url "https://github.com/EmmyLuaLs/emmylua-analyzer-rust/archive/refs/tags/0.23.2.tar.gz"
  sha256 "6c4d380dd34ee3600684f4bfd35d7fd98d2c77334a3b4a6ad46ea5af106f667b"
  license "MIT"
  head "https://github.com/EmmyLuaLs/emmylua-analyzer-rust.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e16461208fad2e582cd41e9c5093039bdc3332d16323a8cc39c74bc18dad4a1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9422f026e00fcca9fe07c96097483e5d9b89fc28126afcce70d06ebf64045587"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6e97062d38d8f9d69ca593c7e5d61022168b2df7ed8f0928774425b5e7c1aba"
    sha256 cellar: :any_skip_relocation, sonoma:        "01f1e0a02875a0f11330cd51b1b1e354d26f7d755739a75cd10ce9a8ec5c2b76"
    sha256 cellar: :any,                 arm64_linux:   "3d6ed22af077ef30fe1720850b3b7ef0453815007e4f329c49de33ae48b42e1f"
    sha256 cellar: :any,                 x86_64_linux:  "f61d48b4c808bf668601d7f079a8d0fcb6f53f2f1bb66a536dd26d4e08ebb02b"
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
