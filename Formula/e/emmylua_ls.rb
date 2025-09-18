class EmmyluaLs < Formula
  desc "Lua Language Server"
  homepage "https://github.com/EmmyLuaLs/emmylua-analyzer-rust"
  # The project name is `emmylua-analyzer-rust`, but it contains several crates, not all of which we install.
  url "https://github.com/EmmyLuaLs/emmylua-analyzer-rust/archive/refs/tags/0.13.0.tar.gz"
  sha256 "8e796d8978553c42f03b4d29ffb5e78717dc6954e3eeae92ba323798258e861f"
  license "MIT"
  head "https://github.com/EmmyLuaLs/emmylua-analyzer-rust.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62c18c4a37eed708d8dc427876e46e85967c7297d5a9da15fa12c4eca0cc503f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb3999b1d28914fd8ba25e10adef647cd8737b00c19e473476f61aa720abe688"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1c2c25c16de040b1b81c743fe4d79b560cda326dfdb672daf4a84d9d04f8c4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73a2f96e6591adcab4e023e8b30dbe93d69a7673b702c9852aa2996d8de0ba0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "43c14ac21369ff9275fdfa6b4ed2f660c25dc7c049fe5768b00b4a96d4b6512e"
    sha256 cellar: :any_skip_relocation, ventura:       "80db0450c6051f0691ca5c11b813636b6d53c9af95c324992a8b250708215bea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "505c8e0489d338c71ed1c24a9cc896a20d34d3f3b7c79f5966f620797815d844"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f591ad4521b74b1fdb9622241aabcf070b38f011600d4ca13889edece8b9ff2"
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
