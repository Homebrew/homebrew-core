class Marksman < Formula
  desc "Language Server Protocol for Markdown"
  homepage "https://github.com/artempyanykh/marksman"
  url "https://github.com/artempyanykh/marksman/archive/refs/tags/2024-12-18.tar.gz"
  sha256 "7392822c196e6bef68fc1cef3a873aac79b27bf95478c2419ea4761651a6a957"
  license "MIT"
  head "https://github.com/artempyanykh/marksman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9d34d209ff066fc670ef526ef4e1921698345ce643eeeb8e2d5dfff80bffbfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abb4ee028058af4d4f464c83157d3f49783c96f2917fd671bdff11a8dcc3c6bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bea0c8d782eb874e6a3f92dc47884e1e71afaba9741a6c705ef5790c5aadae1c"
    sha256 cellar: :any_skip_relocation, ventura:       "5d4e38cbf29fea160804f0181cd6a000a877aad5b74222a0fc8f4be2aff1b452"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50abec82ec280c5c3c35c770fe08bceeafc3bb20ba8e474843b15a49272907ff"
  end

  depends_on "dotnet@8"

  uses_from_macos "zlib"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "true"

    dotnet = Formula["dotnet@8"]
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
