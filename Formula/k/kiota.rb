class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https://aka.ms/kiota/docs"
  url "https://github.com/microsoft/kiota/archive/refs/tags/v1.35.0.tar.gz"
  sha256 "dbf6050dc24f80c74a354893cc4c0146ddf7b9bc255d3d95a06e9fa17dc4ad9a"
  license "MIT"
  head "https://github.com/microsoft/kiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a9c77a399ba1c195f46f0ac9fba316ca3961b95bd932f692a488151161b30d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78f4b23e3ec267cb0ab4e12ba3d759a664fcb6e69ebcbd29edef04d820021312"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e14039346cb054f65d1e2c1e13a76ad431298db00bb9930a35d36f7c9d7352f"
    sha256 cellar: :any,                 arm64_linux:   "06e6370227aca99b8fd718f27513e493a3be1d169f0f21de6a46782bf3bb12f2"
    sha256 cellar: :any,                 x86_64_linux:  "073a5802af59ff09c924102e3cab02b37f0f98d1bb885b2cd60971a46a6402ef"
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
    assert_match version.to_s, shell_output("#{bin}/kiota --version")

    info_output = shell_output("#{bin}/kiota info")
    assert_match "Go         Stable", info_output
    assert_match "Python     Stable", info_output

    search_output = shell_output("#{bin}/kiota search github")
    assert_match(/apisguru::github.com\s+GitHub v3 REST API/, search_output)
  end
end
