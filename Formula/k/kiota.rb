class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https://aka.ms/kiota/docs"
  url "https://github.com/microsoft/kiota/archive/refs/tags/v1.38.0.tar.gz"
  sha256 "b69b1981d4405224a5dbe02c21f43be9c753e5dd99c1f499b8af269a24fc1488"
  license "MIT"
  head "https://github.com/microsoft/kiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4c6732d7452a032bed616d71819efa38983da8bd63c10a47bee8f0daa5592e5d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1e3b3f5ca15c919470e2e051e69537454afa69c50103f9678f17edb56dbe7e6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "65b400bb7614f0f31db196cd565d0d4cc500d55ccaffd42b63f579b5e97579bb"
    sha256 cellar: :any,                 arm64_linux:       "75eeed6f8c582fb85e8e1f9feaee5a57ee433c2661307432a571227a9e4d6549"
    sha256 cellar: :any,                 x86_64_linux:      "d639fbbdc21a9ec0dc2e4445050e18ec4f2c7dfc422e7240b7f9ca127f89005e"
  end

  depends_on "dotnet"

  def install
    # Ignore dotnet version specification and use homebrew one
    rm "global.json"

    # .NET named mutexes need `XDG_RUNTIME_DIR` (or `USER`) on Linux, which build containers may lack
    ENV["XDG_RUNTIME_DIR"] = buildpath

    dotnet = Formula["dotnet"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:TargetFramework=net#{dotnet.version.major_minor}
      -p:PublishSingleFile=true
    ]
    args << "-p:Version=#{version}" if build.stable?

    system "dotnet", "publish", "src/kiota/kiota.csproj", *args
    (bin/"kiota").write_env_script libexec/"kiota", DOTNET_ROOT: dotnet.opt_libexec
  end

  test do
    # The sandbox denies FSEvents, so .NET's config file watcher would hang
    ENV["DOTNET_USE_POLLING_FILE_WATCHER"] = "1" if OS.mac?

    assert_match version.to_s, shell_output("#{bin}/kiota --version")

    info_output = shell_output("#{bin}/kiota info")
    assert_match "Go         Stable", info_output
    assert_match "Python     Stable", info_output

    search_output = shell_output("#{bin}/kiota search github")
    assert_match(/apisguru::github.com\s+GitHub v3 REST API/, search_output)
  end
end
