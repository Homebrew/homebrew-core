class Marksman < Formula
  desc "Language Server Protocol for Markdown"
  homepage "https://github.com/artempyanykh/marksman"
  url "https://github.com/artempyanykh/marksman/archive/refs/tags/2024-10-07.tar.gz"
  sha256 "4b3c107717344508c8de66efe4a847d31a8f77040908cccfef1f3deec4ffad96"
  license "MIT"
  head "https://github.com/artempyanykh/marksman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d41cd9570edf1216e05c5b1b9c24e53245e5d8f62eff01af041ba9dc13e74130"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45f594a715a7c80886deb22d7cd75de2abb8742667ece6cd77a6c93b272b4cb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9d3428560916765a1551be5e6c8b3fdb3a4141c686f876220aa06d3e2d3f9e8"
    sha256 cellar: :any_skip_relocation, sonoma:        "079b494392db99c537d82d5ac970289101ce6cc4522342957c8e001f06ddf4a2"
    sha256 cellar: :any_skip_relocation, ventura:       "0c03ecf16e58b03c2917fea6285d0781b791948795b12b872a35a6b131cbeb53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c076fc10cfc0eed8b3cb367ca3736b9483c3af515733ac8125309eead36c15bf"
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

    Open3.popen3(bin/"marksman", "server") do |stdin, stdout|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"

      sleep 3

      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end
