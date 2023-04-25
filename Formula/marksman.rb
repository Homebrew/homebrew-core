class Marksman < Formula
  desc "Language Server Protocol for Markdown"
  homepage "https://github.com/artempyanykh/marksman"
  url "https://github.com/artempyanykh/marksman/archive/refs/tags/2023-04-12.tar.gz"
  version "2023-04-12"
  sha256 "ffbe10220518dc53734a5e272e3be76493bde37f081303ce360e7208aba49cf6"
  license "MIT"
  head "https://github.com/artempyanykh/marksman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fe1c4e82d98fd52ed45fca18b295b866a497bbf6af7565ae20c5cd1f88d3be9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5252378d455226e0af639f8548893cdd6a44203fb082ae889243b66813b0c449"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d83ac7f794fa2611eac254139006bb435d2f208bc65d50fb2015e34c06aac25"
    sha256 cellar: :any_skip_relocation, ventura:        "82df6cc73703f6bb8cfe796f04cd0bea67cea5292451865c742dd7e2d52e7f20"
    sha256 cellar: :any_skip_relocation, monterey:       "8ea44a89587c1d5803615fc5a64f33a94b88c03d1df5546b6f9fc08fcadf9eb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "b77fe6607c09bec9f80552c785ebc3eedfcc692dddb8bd9fd716c97330c0ec39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b8b3ae7e0ab710cd8cccc1c2f587c03936601f3686e42f2f9ee15a39e0a242a"
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
