class EmmyluaLs < Formula
  desc "Lua Language Server"
  homepage "https://github.com/EmmyLuaLs/emmylua-analyzer-rust"
  # The project name is `emmylua-analyzer-rust`, but it contains several crates, not all of which we install.
  url "https://github.com/EmmyLuaLs/emmylua-analyzer-rust/archive/refs/tags/0.22.0.tar.gz"
  sha256 "d1b7eec2f607b58a2bb3599530de3ef206911f521d4e5a4eb229d1fd6fbee7c2"
  license "MIT"
  head "https://github.com/EmmyLuaLs/emmylua-analyzer-rust.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83ce19dfdd252ee87882cf7d3770b235ac44c8876fed02689f84cdf59e0a8837"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc10452701348db882ef7cce63ebca6fd027290126c68ad3579c7e2237598403"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1ec9d2c6115393edec4946eb057cd10885ae853ebb92da135030949c1d455fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "7384ffd4ed031b2db648f25da9c52c5345999403d251f1f5b28e915eacf494da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf266cc83ec53bd33be15f83b0a922b4e67d3ff78f2a4dc4aa4786a3f3a5a1e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b51cce4370d35b9c5caab2a94e2d4d813ccd706f49fa8251f6e587dbbfe6ac9e"
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
