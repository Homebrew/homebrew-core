class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https://aka.ms/kiota/docs"
  url "https://github.com/microsoft/kiota/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "22ae2c86276a4fadb8fbffa956a9a36dbb2afe7af3e988858a53e3c7b0b9d6fb"
  license "MIT"
  head "https://github.com/microsoft/kiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e9c66c91f5ef2b18e89aa4ccec8417711a7fbf6485fd0585c59d19112a21743"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c038fe33ad77501ad5f09c7a7bb86194e51fb98b42086ff0b5ec20fd98b018a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2c910e355a8f1c101c4f91f7ec31d86270722e121090a5e1bbe1e48dc421c87"
    sha256 cellar: :any_skip_relocation, ventura:       "a50a83adf8b4341e334b1990e18bec48b52d7cdb679974a2f2ad434452ff0421"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47b04dd0b5ae4f5d4bacbbe17b03d58b74cb60a2145acab83ab6da7872a2cc8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b82c113a8953e61716bf2a301a62ffcf68eed59f8b2c3d88edf53d6edaf3186"
  end

  depends_on "dotnet"

  def install
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
    assert_match "Go          Stable", info_output
    assert_match "Python      Stable", info_output

    search_output = shell_output("#{bin}/kiota search github")
    assert_match "apisguru::github.com                            GitHub v3 REST API", search_output
  end
end
