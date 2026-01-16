class Marksman < Formula
  desc "Language Server Protocol for Markdown"
  homepage "https://github.com/artempyanykh/marksman"
  url "https://github.com/artempyanykh/marksman/archive/refs/tags/2025-12-13.tar.gz"
  sha256 "7dcfb73538690d16950aa43a78aa58c1c144548851797e6088d3e76cd8a3f2ba"
  license "MIT"
  revision 1
  head "https://github.com/artempyanykh/marksman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b1b0ec899f0fb55ed6b33d1d7487d45cfc8e6f18a2a2b9048186af27c3f5f0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a44ba9aa0fc0e392d7254dd0638f206feb5ecf7bceca5687a6179e2e457c7dcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4836611c44e4e6bcac6b494a95b3b8b948480694c448147b296562f00bc8ebd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fd0ef1fefc0e8ee9f13f3b3e6159cad5dbb743a9b473cc97a6660908f3b5d6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c4c838ccd87eacfb2d4a4ff2bafb4e756b0be3bae47db548009c0cc86b4cd1d"
  end

  depends_on "dotnet@9"

  uses_from_macos "zlib"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "true"

    dotnet = Formula["dotnet@9"]
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
