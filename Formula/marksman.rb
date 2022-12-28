class Marksman < Formula
  desc "Language Server Protocol for Markdown"
  homepage "https://github.com/artempyanykh/marksman"
  url "https://github.com/artempyanykh/marksman/archive/refs/tags/2022-12-28.tar.gz"
  version "2022-12-28"
  sha256 "6b2dd3b6e2c1aca4308a1aa900886635c24aac3ae4f2f8f3f3fbf65d951e62cc"
  license "MIT"
  head "https://github.com/artempyanykh/marksman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04385d0271646045623b78c0bc73d19a198dd4fe6ec8d5332f662e8e1a282888"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b4a1d1401a1d3e8d4b9b6685d97461179f86d56a5cd642630324364ece55047"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "797eff0d46e753581643e147af6d6589d81af4f9a577df12ae96cc00627e344a"
    sha256 cellar: :any_skip_relocation, ventura:        "82fad9d6455c1555ed560ef96e9433fb0618b3154018194250747b27ea97d314"
    sha256 cellar: :any_skip_relocation, monterey:       "f1f2fa989f61f1aa4644d5a136de357d3450b2cde07aa6c2c5881bfe5382c45a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4cab617d1bbe4cdd671158de18eb97cec829f305874848b0a12c3eaa21a8eea5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "043414721228cf83a99623c4c4dfc2669fe8fce8ee8ba2d08df1ce207e9c981d"
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
