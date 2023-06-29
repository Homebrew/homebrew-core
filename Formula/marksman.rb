class Marksman < Formula
  desc "Language Server Protocol for Markdown"
  homepage "https://github.com/artempyanykh/marksman"
  url "https://github.com/artempyanykh/marksman/archive/refs/tags/2023-06-23.tar.gz"
  version "2023-06-23"
  sha256 "23b6240d981cb4dfb05eeac942e0e991727f938cb5c42b90f5032cba001702a9"
  license "MIT"
  head "https://github.com/artempyanykh/marksman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04eadfd7d030fe9ccd2d5c908790ae289d51d79966e7f9b14b7dd5d7563af1ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84c9f93a6472228ab9572c0138d87ffe921e94e7fb686535f81a8ba23d089d51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d264ddf3095ce4538fd3804c9dbcbb411a3e5a9350bd1bf0958349a27391111c"
    sha256 cellar: :any_skip_relocation, ventura:        "925ef2624f2d10a091d2b7ebb3717f4973c62e792a7060f366c7269627e15d05"
    sha256 cellar: :any_skip_relocation, monterey:       "1cb1bc72b7cd7ac1b7e6cff0a9f5fd0d22711bd84bea9781700a02712ff63afa"
    sha256 cellar: :any_skip_relocation, big_sur:        "306f52e141be9d93bd9ead8a6d8c0f95c14d541e306e3c5cd9f33581513c715f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "130fae2e4026b739538354ff99f5956471596e5a375f12cd6402cc552ec884cb"
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
