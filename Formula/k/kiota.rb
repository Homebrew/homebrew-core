class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https://aka.ms/kiota/docs"
  url "https://github.com/microsoft/kiota/archive/refs/tags/v1.36.1.tar.gz"
  sha256 "e91e748a75d889d202f8fd121bfc04336060fd3f6c84c86ddff182beaa85700a"
  license "MIT"
  head "https://github.com/microsoft/kiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "76b8ef63aa121512cd98a828bfbf7095f55893d867eaee4b14077fa2f39fe5d9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c62868cdd91e43728fc54faf8ffffe1cb2ce90464e92b6a9c05373e86d27a9c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "79f1c7ae62a282085c532b82ba20daa680ef5259f2fd77d87db2d2ca4a45e347"
    sha256 cellar: :any,                 arm64_linux:       "8c0dab92d8eef32b252a96d8ccfe0f9911a01f9f4345d41e0c71eb298a9f2630"
    sha256 cellar: :any,                 x86_64_linux:      "b1a775eafaf6e40075ce5b0d5dfba52ea1a1a45a98a615575794344924c5a8c5"
  end

  depends_on "dotnet"

  def install
    # Ignore dotnet version specification and use homebrew one
    rm "global.json"

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
