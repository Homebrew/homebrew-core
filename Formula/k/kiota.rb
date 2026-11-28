class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https://aka.ms/kiota/docs"
  url "https://github.com/microsoft/kiota/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "0008e9ffda62e2b962114c800867b0fb7f082706906956862a3fb48e4464bf2d"
  license "MIT"
  head "https://github.com/microsoft/kiota.git", branch: "main"

  bottle do
    manifest_sha256 "5321c953b9babc89351bdc5ba1b7eaad85cf44b1308ec0ab8c810a2cac643df5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f72d740f329b5b9e1a164a7b323b7e581d9b0b677f45bc4e7a627279fa5255b8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "70cfa68191e80ff4af14e8140be4bdd610105a29569a8fea30ff57d676d54e7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "38604c4cc67778a9392c97a5d675812a2738805949225e6a74a31dbbb551f54c"
    sha256 cellar: :any,                 arm64_linux:       "a35a167b17eff4419cbf8642efcbb2480dfad7578dba40e72eaac8b13551ab72"
    sha256 cellar: :any,                 x86_64_linux:      "2c23bd5b0b248b1734a4810d06d094645ced2f13ad76e5ce5d54cfd6e352539b"
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
