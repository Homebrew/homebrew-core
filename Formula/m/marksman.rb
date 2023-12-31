class Marksman < Formula
  desc "Language Server Protocol for Markdown"
  homepage "https://github.com/artempyanykh/marksman"
  url "https://github.com/artempyanykh/marksman/archive/refs/tags/2023-12-09.tar.gz"
  sha256 "1f4f5b76c2679426f6a5e93d50e15deb4faadad2da18e70bee66de1dbe68342a"
  license "MIT"
  head "https://github.com/artempyanykh/marksman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72a80209860d562e1e0c6d275ad9de967c3f8a2406bd985c117d7c606a073f2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c589b508c7dedcb77330d6d08fcd77918df7f21a2d2034136993445ab55b3689"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30b4ec073d1faa78b582e48cc999b96e3688d4a3d240b3042dcf8e06a91f9978"
    sha256 cellar: :any_skip_relocation, ventura:        "87621c040156f28adad1b60acac7b0e8696fd83caaa7fe4258242804f1b0682a"
    sha256 cellar: :any_skip_relocation, monterey:       "70e10fecda6836850b0c9cdc06fc1897569735421d9d9b1702dc5191ed76d1a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f6d8ca3bd0313b53f1b9addf4c6c84840e9461bf16766779f09910dd58f3f0c"
  end

  depends_on "dotnet" => :build

  uses_from_macos "zlib"

  def install
    bin.mkdir

    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "true"

    # by default it uses `git describe` to acquire a version suffix, for details
    # see the GitHub pull request [1], the resulting version would for example
    # be `1.0.0-<version>`
    #
    # [1]: https://github.com/artempyanykh/marksman/pull/125
    ENV.deparallelize do
      system "make", "VERSIONSTRING=#{version}", "DEST=#{bin}", "publishTo"
    end
  end

  test do
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

    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    Open3.popen3("#{bin}/marksman", "server") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"

      sleep 3

      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
