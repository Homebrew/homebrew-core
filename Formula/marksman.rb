class Marksman < Formula
  desc "Language Server Protocol for Markdown"
  homepage "https://github.com/artempyanykh/marksman"
  url "https://github.com/artempyanykh/marksman/archive/refs/tags/2023-07-01.tar.gz"
  version "2023-07-01"
  sha256 "236e5b9d5043a96f3fd2a7e6093ddd9d0463b6189810fe1790fc448ddb338718"
  license "MIT"
  head "https://github.com/artempyanykh/marksman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "237fe0deef835260dde85f7e25754a972bf4624df18070cbe0fb0191870c6ab5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b677099be66126e91ae5cbe57f011efbc09a6da069dd3d283bafa27093c5459"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d535933f13c20afaa474db558c8225ce3b7ca162660e8aba4267231bf39668b7"
    sha256 cellar: :any_skip_relocation, ventura:        "430ee52a6baf1448575ee560cd78474fe21b7579173e725f2b7e0dc96876ab90"
    sha256 cellar: :any_skip_relocation, monterey:       "93608ae46b56c06ecdfb9bbb27c6082b3f8b04c3f155f03d363341fa7e0c616e"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a6a506ab3eb694b2bcddc4f677aae006b2456d13a16cc2bc7969e5f67941ce2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f539f9eb28dc9e8c90d2818181e8c2ecad800f2fb306aa8e76f75b7640cdbfd"
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
