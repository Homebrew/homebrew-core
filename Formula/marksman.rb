class Marksman < Formula
  desc "Language Server Protocol for Markdown"
  homepage "https://github.com/artempyanykh/marksman"
  url "https://github.com/artempyanykh/marksman/archive/refs/tags/2023-03-04.tar.gz"
  version "2023-03-04"
  sha256 "3e3db71c3b93524aa1931464c0030f642b9b5596d3d6b7a0d4d483ef3bc2fd2d"
  license "MIT"
  head "https://github.com/artempyanykh/marksman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7081de73c921787a40b329b00536750f9091c079bd96e738acb1964f9105fddf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fcd7846a8aac0c9db8f4a36bcfe91ffcfabaa92fd989547ed65c36ccf7d2f1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd1d3cffc5a7a301a436b9c28c18a4cb3ed3cdf778a0971e1b79ead792188976"
    sha256 cellar: :any_skip_relocation, ventura:        "9fb78baa82b2987b14f7446a91af2dc0e43a9343cc455fdfa4f90df6ede71cab"
    sha256 cellar: :any_skip_relocation, monterey:       "b6130ce3839799e27cbad5dd5f03e5561a58ea72e5e79b766719379d7ac013dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c74dd14f5f9a860cf41ec2daec84045f6ce648764aaafa5db52e263773c158d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef590da29698b782ededc7344a9b202d856ebeb847784abd0680fd543e406650"
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
