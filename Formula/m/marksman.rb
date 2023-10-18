class Marksman < Formula
  desc "Language Server Protocol for Markdown"
  homepage "https://github.com/artempyanykh/marksman"
  url "https://github.com/artempyanykh/marksman/archive/refs/tags/2023-07-25.tar.gz"
  sha256 "0b04ab2eeb185ab321f0ab0f7ab19c02d91b8c2ce377d6ea2af494cd1ef48a7b"
  license "MIT"
  head "https://github.com/artempyanykh/marksman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf3be1cdc036e59ecba83f07cc51ea06b8d7197b0ac531019bb6e264b08bb557"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3f90276b1f17a84573149b4380188190a8cf62a66cf62644b0b5c38d2c4fa2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "daf54f16db3c68f0314ebb56c98287adbd147690049209fadfe2acbfe14eb548"
    sha256 cellar: :any_skip_relocation, ventura:        "5534cb88d413b457cc92d37f506d3b373abb750cb5a0bf852ebf7cbeeb05fd53"
    sha256 cellar: :any_skip_relocation, monterey:       "aee1de132cd15a34a513c8d8a3f7e80f88b77d88d82ecfcd69122e7c930f58a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcde5660ad404c33f7e04a650ea42d7b459d99d4c3256374d3e23f5b8edae0b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb8eb4232c1cc858efe61d63bbac0192ca11a9d5a5881bc5f05ee4a20a0ccf7a"
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
