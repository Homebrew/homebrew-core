class Marksman < Formula
  desc "Language Server Protocol for Markdown"
  homepage "https://github.com/artempyanykh/marksman"
  url "https://github.com/artempyanykh/marksman/archive/refs/tags/2026-01-28.tar.gz"
  sha256 "e6f1b96f8c43447ed4fb408d54b350441f1c5da843d22e0e2acbc2cda320ca74"
  license "MIT"
  head "https://github.com/artempyanykh/marksman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29c6e79b8935db56c7507f7149d84b3dff55f8297b6085c1acfbb472c047ea1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99abb470342d4efe1894cb51d2702c23809604c5b4a2104bac068e2635597c70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c3b4b421b2f073217e250bbb3bb099543f55cda069f0785b74c4d8069bd77a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "116ffbe2f558cdba1ccef80c0e139652c0794278c50ebd4bb799fabdc01b540d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cdf87dfe87e83a2ab79f5f15081b60ac3e6ba14465a436ea639cd76e5b714ce"
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
