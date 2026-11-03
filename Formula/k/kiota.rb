class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https://aka.ms/kiota/docs"
  url "https://github.com/microsoft/kiota/archive/refs/tags/v1.38.0.tar.gz"
  sha256 "b69b1981d4405224a5dbe02c21f43be9c753e5dd99c1f499b8af269a24fc1488"
  license "MIT"
  head "https://github.com/microsoft/kiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "05961bdf93ea6918d19c79736ff97e98063773f86427f447f542d4c71ea56372"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "58a41e7b0c27922570221f09a7c9a9a9906417b125bbb0fb15aa74810a948cbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d0539e33319b3813aca8ad065f8dd8ba9dec1a635a0756287899cd488995309f"
    sha256 cellar: :any,                 arm64_linux:       "7ddf320263d50bb16ba8b6f66fff7beb6dd3f9d9cd5c7615797a0ad2e08da7b1"
    sha256 cellar: :any,                 x86_64_linux:      "0b325347e657868ff57d9a9f32c8f95dd8ade2a27c205a22d3ec93656199cecb"
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
