class PackageVersionServer < Formula
  desc "Language server that handles hover information in package.json files"
  homepage "https://github.com/zed-industries/package-version-server"
  url "https://github.com/zed-industries/package-version-server/archive/refs/tags/v0.0.10.tar.gz"
  sha256 "0ea78ae53981223fcad9eed35cf0f0e4a9f70619dafcff358d2efe11ab1b641d"
  license "MIT"
  head "https://github.com/zed-industries/package-version-server.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "package-version-server #{version}",
                 shell_output("#{bin}/package-version-server --version")

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

    Open3.popen3(bin/"package-version-server") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 1
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
