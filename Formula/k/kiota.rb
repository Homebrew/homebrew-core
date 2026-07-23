class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https://aka.ms/kiota/docs"
  url "https://github.com/microsoft/kiota/archive/refs/tags/v1.34.1.tar.gz"
  sha256 "83d531e2d1bbb9a0e4c5f9e7b5a881981fa0ed4a1cf9dba4939d3cf2b69be829"
  license "MIT"
  head "https://github.com/microsoft/kiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ccb4dee1642df6b127892c91539a723e45c4b7ac93c2f264f862793945965ddb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "802a3bc2e48be8e3bc87fc5a37c4fc59258f245ee53452e28acca9b419ff6080"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "825f9a0206ac43de1788731f291af4f5ff560a9fe33fd2e2fb1673faf1fa0c29"
    sha256 cellar: :any_skip_relocation, sonoma:        "88431de5820615cf24253567c49782f47295369f74c5de20b14f8f6f56ab65b8"
    sha256 cellar: :any,                 arm64_linux:   "584f9688a05b42a09fcdb352e31f55dc361ff6907e606caf0f9f70803e27ec90"
    sha256 cellar: :any,                 x86_64_linux:  "28cd10c79a478bb24b12af611d7b26588db409f88cbee61ce26aa55853cff5f3"
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
