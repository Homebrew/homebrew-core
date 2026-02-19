class EmmyluaLs < Formula
  desc "Lua Language Server"
  homepage "https://github.com/EmmyLuaLs/emmylua-analyzer-rust"
  # The project name is `emmylua-analyzer-rust`, but it contains several crates, not all of which we install.
  url "https://github.com/EmmyLuaLs/emmylua-analyzer-rust/archive/refs/tags/0.20.0.tar.gz"
  sha256 "5ddee74a31e63598ec619b73c483ab8d66c126f89b28447014d0e012bab57d1e"
  license "MIT"
  head "https://github.com/EmmyLuaLs/emmylua-analyzer-rust.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e12707815c52a8b34f92c7375a6a7aeb774a2a85e7bcdc19c832f91ff4ffac8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ea2cb788210e3134e9e7819f2d54d0a536a14936a18d93da52678ecc9f830a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50ae28c1eac3beb777e00ebf7b474e050598d80a3a858e91bd30fd65fb62fae5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c85f288329d68c59554098bf05efe5ccbe6bbd6440b31df95d3929986bd6f0f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1def74cd5676afa7d94182c398868798a01d5f0823af89489bf62e772d80924c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "497553f3b02b246caa20201721945dd35bc2b9dea507647f54e70815edb75fb5"
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
