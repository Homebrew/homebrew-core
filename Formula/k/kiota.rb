class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https://aka.ms/kiota/docs"
  url "https://github.com/microsoft/kiota/archive/refs/tags/v1.32.4.tar.gz"
  sha256 "49b82ebfc1c8547e021c42cda5a21cbe4f231185baa92e7a4fa8373db25d4ec0"
  license "MIT"
  head "https://github.com/microsoft/kiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5b8cc44f23c8881732b63bc7d72175097f60a0c72ae47da17d7923f7dc12e6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "deb45a4b2ee0ca72231909f327426c90c9cc432918bef879777ddccf6da0c71c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "add3e4f75271215ff71e9e12d91807c3ad91f9d38f70ea11774aa8cb5f9103fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "eac13299b67e4e678a3ab2aedb5c204d2614364db28683c2b053c6295304d4d5"
    sha256 cellar: :any,                 arm64_linux:   "6221a83e2cd7744047e78c53e8247f2e86ea3b7074ae07571ff8b1a0e6e2232a"
    sha256 cellar: :any,                 x86_64_linux:  "f52ebc41db21c01311b53e59d954c83e24f40b1811ecafee9c57571abf2c75b9"
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
