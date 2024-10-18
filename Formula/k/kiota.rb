class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https://aka.ms/kiota/docs"
  url "https://github.com/microsoft/kiota/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "8a6d0d31d71a90edea434df6df4a8bfa96d70e781e64b72e490e295a2accf1d9"
  license "MIT"
  head "https://github.com/microsoft/kiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab074e15fdae5c836c81ae19c8e339150947c82a4e1efc639456429ec2b7862b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a10f7f7355a83251ea704c4c14243a1e3ddc22bd49d38eea5a553fd1ca587e84"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10a391964f4a7b146d9db31e7ae4ec462318fbd596b6fb39d1e258a616a1b0de"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0bc1e4294e0577800927e03d862875877093f9fae7db4e49d2d885c6674599e"
    sha256 cellar: :any_skip_relocation, ventura:       "330d081563bc910d265c8865827f44413d331785c8d1afea2f6cbedc059e59e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c093b4380d75606e739e11123632a8c943ac4f5ff42ef83c6d4785d9c71bbdce"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
      -p:TargetFramework=net#{dotnet.version.major_minor}
      -p:PublishSingleFile=true
      -p:Version=#{version}
    ]

    system "dotnet", "publish", "src/kiota/kiota.csproj", *args

    (bin/"kiota").write_env_script libexec/"kiota",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
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
