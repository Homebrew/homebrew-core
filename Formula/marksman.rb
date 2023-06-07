class Marksman < Formula
  desc "Language Server Protocol for Markdown"
  homepage "https://github.com/artempyanykh/marksman"
  url "https://github.com/artempyanykh/marksman/archive/refs/tags/2023-06-05.tar.gz"
  version "2023-06-05"
  sha256 "bea4ef7f4604a5357ee86b82cfbd42c6a3eb16a0c75735b576c075f1db0a3f6b"
  license "MIT"
  head "https://github.com/artempyanykh/marksman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "015214c73d24c989f8e5799ce18b259d0dac0cedb9c2f077db21b571d535c255"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc3acd4b54f644599b2323e43481f6de9fe8bc42187e4b37a3a077721ae72f9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c11575a20c1a1b337c68034e56832c5024e20883f398bbc75b5e794fbe3ee39"
    sha256 cellar: :any_skip_relocation, ventura:        "f468a4d1046cc43577c5ac2b767e57955bbd49863cab08b04477cf532be971a5"
    sha256 cellar: :any_skip_relocation, monterey:       "de4d4c1fbf9ad36b0f5ff3c0fcaa46075c3cb773bf3e906e5b1354de5abf17d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "3cb4ce78b9260eff2dd8ebfe9799ad19c11b157fd64e927f95bc6030950b7687"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c53ff620332e331b9e5a0ca11dca4c951f94a69a0095409b2f35370aa7899bb9"
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
