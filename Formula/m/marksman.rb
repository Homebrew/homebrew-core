class Marksman < Formula
  desc "Language Server Protocol for Markdown"
  homepage "https://github.com/artempyanykh/marksman"
  url "https://github.com/artempyanykh/marksman/archive/refs/tags/2025-11-30.tar.gz"
  sha256 "b7d6346097823e0903f66d5557a5f895225e9d948fc9574dd81723d1f5b013bc"
  license "MIT"
  head "https://github.com/artempyanykh/marksman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03cfd0f546f5d6cb5c09dcb6531dd6632ab02e59c49a974dca2151186fb7a773"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4caa148f860c111a6c8d71c1364159cded39104678ffb63ca7de8502ac81e5a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35ae8b8458a966cd56bb18e8f428a0be772f8dd9e42cf80b4a09ea3e19314c11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9ecbc072ec56430af3c6c2a2a3c40f67b2819f492d85bef57155cc40450a3bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2714f6157b405c734b619fcc7cb2eddc28a3c58a5d3fda3c801728496dc1a9c4"
  end

  depends_on "dotnet"

  uses_from_macos "zlib"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "true"

    dotnet = Formula["dotnet"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --no-self-contained
      --output #{libexec}
      --use-current-runtime
      -p:PublishSingleFile=true
      -p:DebugType=embedded
    ]
    args << "-p:VersionString=#{version}" if build.stable?

    system "dotnet", "publish", "Marksman/Marksman.fsproj", *args
    (bin/"marksman").write_env_script libexec/"marksman", DOTNET_ROOT: dotnet.opt_libexec
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
