class Marksman < Formula
  desc "Language Server Protocol for Markdown"
  homepage "https://github.com/artempyanykh/marksman"
  url "https://github.com/artempyanykh/marksman/archive/refs/tags/2026-02-08.tar.gz"
  sha256 "a3ba5f8ef5be5d7ede2ec5ae9f303d2d776f476734ff66254be8e6df0e0f090e"
  license "MIT"
  head "https://github.com/artempyanykh/marksman.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72025099971ddcc8570f9de4c0cde1a90a46cd789de0481ed5e0ed41575dd7a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3f85402db8d81eafb281218f31eb2409bb0ee88c64d1b7eae3767e5d9d48cc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69c265280db27209671cb17f5c9ef2e038b5139c5e20a2189a932bfdac317334"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "998878e87dfc282f0d00d68619f918e93f7fe1ce6346721ee0388627d4c58a9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffcb1bb604a483eebb0305b7f7d19ed4b3be2f6468115ebf28540b942b46ba04"
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
