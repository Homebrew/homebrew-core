class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https://aka.ms/kiota/docs"
  url "https://github.com/microsoft/kiota/archive/refs/tags/v1.38.0.tar.gz"
  sha256 "b69b1981d4405224a5dbe02c21f43be9c753e5dd99c1f499b8af269a24fc1488"
  license "MIT"
  revision 1
  head "https://github.com/microsoft/kiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bac61d14a170d7a7acced599b19f4a97509f20fc8d34733288c2df9bc1c114f8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "27bcb685f6056af1c2f6cff65e9db1cd07a3c7974e5131031b9345e0fdc0946b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cf340bb3ec32c8caf2c5aa92b7dd58cf3518c7641837c8b0d956620392c9d765"
    sha256 cellar: :any,                 arm64_linux:       "59ca8306ec812a288353316bf8afba06b88faa6830ce90563a923f456acd243f"
    sha256 cellar: :any,                 x86_64_linux:      "53a71bcc5490da8fd3941019d09c2a82d54b97c49c21922bddb908ddc4db0dbc"
  end

  depends_on "dotnet@10"

  allow_network_access! :test

  def fetch
    ENV["XDG_RUNTIME_DIR"] = buildpath
    # Ignore dotnet version specification and use homebrew one
    rm "global.json"

    system "dotnet", "restore", "src/kiota/kiota.csproj", "--use-current-runtime"
  end

  def install
    # .NET named mutexes need `XDG_RUNTIME_DIR` (or `USER`) on Linux, which build containers may lack
    ENV["XDG_RUNTIME_DIR"] = buildpath

    dotnet = Formula["dotnet@10"]

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
