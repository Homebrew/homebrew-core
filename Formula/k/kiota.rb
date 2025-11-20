class Kiota < Formula
  desc "OpenAPI based HTTP Client code generator"
  homepage "https://aka.ms/kiota/docs"
  url "https://github.com/microsoft/kiota/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "8d75ae103efc94edc0615b1a7427ce6ef970fde389f3f4de5722eec97bcb4860"
  license "MIT"
  head "https://github.com/microsoft/kiota.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b53629836e75eaac33ca417ab050311a263365f921d053e43a926ff1a6d60e8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2455e0baf73eb677bba2cb4ee186a0e08a8d919e9d7f650cc4ba4e331da0faa8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b27803ce4122c455e5ad33668e3985cef4ada574259d4c62a4825fa3aeb96d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08605532539ded3e7f61638cee291649055f315d4385683121c370e5bd5524f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b933531887d8898bfc1a8f877d6221672f16950d70ef9fd37915d0a263577e0"
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
