class BaconLs < Formula
  desc "Rust diagnostic provider based on Bacon"
  homepage "https://github.com/crisidev/bacon-ls"
  url "https://github.com/crisidev/bacon-ls/archive/refs/tags/0.30.0.tar.gz"
  sha256 "c26692de95e7f838aeee2353d8e10bd9b32fb1a97b10f63e31aad0fc05285d40"
  license "MIT"
  head "https://github.com/crisidev/bacon-ls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d2ff68a095584ce52b660d2ca1e8e6605a35b44f5d44380058debf2f817f38d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c66b7399f6768b959e2cda53d317a492750041c29a88832013deb8989602fe83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75b27c9eab7ac917b571792bbfc3952dd24faefaa4143386a43a58be0af95989"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3ec5a595e441a76ae2cd6c037e4be927000045b38502fed2a4976d6484ab5ca"
    sha256 cellar: :any,                 arm64_linux:   "8acdb035237769e7b410365448f68e6c8a608e777da1c2df25198c05f90d2e3d"
    sha256 cellar: :any,                 x86_64_linux:  "121d62a251faddd84605ffb92129f39d6b59b8bd5c31b232fda90a9c3658bbd4"
  end

  depends_on "rust" => :build

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
