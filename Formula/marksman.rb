class Marksman < Formula
  desc "Language Server Protocol for Markdown"
  homepage "https://github.com/artempyanykh/marksman"
  url "https://github.com/artempyanykh/marksman/archive/refs/tags/2023-03-04.tar.gz"
  version "2023-03-04"
  sha256 "3e3db71c3b93524aa1931464c0030f642b9b5596d3d6b7a0d4d483ef3bc2fd2d"
  license "MIT"
  head "https://github.com/artempyanykh/marksman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6b0274aabe69147ce3b4afe1bbc4cffb4556756f2f3333f7f8c72b58a9fe59e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "766c03e5bb7cba9491997e29f3981817f2ed71302fe389afbbdcc084e3ec63ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ec4861018bd54b8410d13060a897135f88cb09e2a3d760b5c61a0ce50a97708"
    sha256 cellar: :any_skip_relocation, ventura:        "60464e204032ce42738199f8181fb8fb6eecb4991a72325a91ef0de463389d0e"
    sha256 cellar: :any_skip_relocation, monterey:       "60f2fa34465e3535a0676ce2b0347585bcaf16558429a9c930153fed93ee3043"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4e62b505423af9cdda46fd5a04eb87750c169e171b40254465ded28a53ccd62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70a8ab1ea920b45c13604d7228927425922bd7f3fab24391f50497e0456b4ad5"
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
