class BaconLs < Formula
  desc "Rust diagnostic provider based on Bacon"
  homepage "https://github.com/crisidev/bacon-ls"
  url "https://github.com/crisidev/bacon-ls/archive/refs/tags/0.27.0.tar.gz"
  sha256 "9c44e6804b11db8edf0df0cfc0b746c7fd5af34c920533e0a939ffad864ae2b4"
  license "MIT"
  head "https://github.com/crisidev/bacon-ls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b2858f4beae66ed094456b8e0572d7b717bbb9ace22b6462407fd58d883497d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78c0c2b732b544fc282465cc182cbae225dc095484384886790aa5b0a01c3c76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed079c378741d235b4e7f93be34d0116fa9a0d254452c95d8e51ae577bb36809"
    sha256 cellar: :any_skip_relocation, sonoma:        "aca8605d281c8a68dc7defaa17569baa57fae43cb8294ef13417dd63b12e849c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55413c43a5e7457eab399a0ccf16e19bc2f7287e47a3f6beda1df21add15cdc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3b31fec055ac2c3b2c20f6b9327d7bf0ba19bd4b70711911fa7248fdf5ee31c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "open3"

    assert_match version.to_s, shell_output("#{bin}/bacon-ls --version")

    init_json = <<~JSON
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

    Open3.popen3(bin/"bacon-ls") do |stdin, stdout, _|
      stdin.write "Content-Length: #{init_json.bytesize}\r\n\r\n#{init_json}"
      stdin.close

      assert_match(/^Content-Length: \d+/i, stdout.read)
    end
  end
end
