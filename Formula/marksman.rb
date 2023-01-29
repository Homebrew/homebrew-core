class Marksman < Formula
  desc "Language Server Protocol for Markdown"
  homepage "https://github.com/artempyanykh/marksman"
  url "https://github.com/artempyanykh/marksman/archive/refs/tags/2023-01-29.tar.gz"
  version "2023-01-29"
  sha256 "dc51cb82a6dfd12d9aae8440695c1009bf618390af5ef226f7b5417524d1d3bb"
  license "MIT"
  head "https://github.com/artempyanykh/marksman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fcd1b7a90e9ec70d36e83edeb8e6001098d68ae5c48047a15d293d954785478a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05f660090de95c14b0f23d5e0feb25fb8935a497c485252c6d441ec518d82f78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04ee968d615acdf4e19902364b755d195783658737aabc35f86e06c67108a7e0"
    sha256 cellar: :any_skip_relocation, ventura:        "96828019d0480600e90e533ada31697dd609e9f1b60d7eec99e0a3bff6e9740c"
    sha256 cellar: :any_skip_relocation, monterey:       "8dd5fba0918d4e7a89171e164268b54ab5a659d294107780125b41fdd1bed724"
    sha256 cellar: :any_skip_relocation, big_sur:        "3bedc8eeaa622ea1fec821197ee2ce2fdf0ec1f5447da4ef50a57c4ca0844e84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c0ddf03a37dffb5ce295f3a67a0f7ccf3659e7076d43038444ca42c139038fe"
  end

  depends_on "dotnet@6" => :build

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
