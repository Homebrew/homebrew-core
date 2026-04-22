class Marksman < Formula
  desc "Language Server Protocol for Markdown"
  homepage "https://github.com/artempyanykh/marksman"
  url "https://github.com/artempyanykh/marksman/archive/refs/tags/2026-02-08.tar.gz"
  sha256 "a3ba5f8ef5be5d7ede2ec5ae9f303d2d776f476734ff66254be8e6df0e0f090e"
  license "MIT"
  head "https://github.com/artempyanykh/marksman.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da4817971f267aaa10093ffe12e568b6e1ba29021c794d66086d9a6956d958c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "438ee8a52c1fc8556cfe210d9c63366306d9fa5bd517fe22f2926d63c3241fd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e10962409dc514362c16d9effcb22c38ccd7c2bf481a3652b745097a057305b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e02dd83e9db94a0092a8007187a0cc10202bfce5fa657dcd3c7b5a2db01c394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d7dc81a783f1866894aaaa40d440034da2230c09389c74a4411697ea9293990"
  end

  depends_on "dotnet@9"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
