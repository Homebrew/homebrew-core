class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https://aka.ms/kiota/docs"
  url "https://github.com/microsoft/kiota/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "826d22b65abcc01f86b781019635a7ecf1a9aa79417eb6adb10ce9a5d0f2a04b"
  license "MIT"
  head "https://github.com/microsoft/kiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c5500ff8a56608219d158610e26dab90aeb9f53ea3a3f5140fc142fb39f4587"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cdc292c3952ddc65e3cd3c162300c48b8629d13bf761048e0957e6349bacd0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "874246ba9c5aad57364ace1e2c764ab8767a2fbecde992826838e266e5aa5827"
    sha256 cellar: :any_skip_relocation, sonoma:        "88746020930e45e44a550802b00916b63ea908c95be49018b0af018cf38b87a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32d80309a623dea753c02a76f67c19ec5cce37d67c22a52ec1efe26297734bdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fd24d5f53bfbc3bd56db1e4df2641974685e5d270f1e50faad5072eb9576e9c"
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
