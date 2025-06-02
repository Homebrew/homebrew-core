class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net/docs/"
  url "https://github.com/GitTools/GitVersion/archive/refs/tags/6.3.0.tar.gz"
  sha256 "b2bc7fef4236722a08ea7441ffe4f5f9214bd24c159d1551d272b875948cd23b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6826ebded9022c6493fb78231e4b223ad0cf7110170fc16b557d30ca632f7de3"
    sha256 cellar: :any,                 arm64_sonoma:  "e2c0a800f6633fe996eca0224a9e97c50fda63d128c8e489886f39317d8242a9"
    sha256 cellar: :any,                 arm64_ventura: "1d68a30d41b7bf600d2985be2573a6cf9fd00a7c1966fd9881606de1f8488794"
    sha256 cellar: :any,                 ventura:       "e57a27abdbc25adf6b913101922b267c89b1141b3234ec0c03fe620f49d56ef5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f469f7175b5a8cf83695a28e9bdd02b7367b19b90b458f45159772e107e77e05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e9beafcf11837d2dd12ee5a97ddf8ebb474ef28329cfd57a44694d677d603ec"
  end

  depends_on "dotnet"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:PublishSingleFile=true
      -p:Version=#{version}
    ]

    # GitVersion uses a global.json file to pin the latest SDK version, which may not be available
    File.rename("global.json", "global.json.ignored")
    system "dotnet", "publish", "src/GitVersion.App/GitVersion.App.csproj", *args
    env = { DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}" }
    (bin/"gitversion").write_env_script libexec/"gitversion", env
  end

  test do
    # Circumvent GitVersion's build server detection scheme:
    ENV["GITHUB_ACTIONS"] = nil

    (testpath/"test.txt").write("test")
    system "git", "init"
    system "git", "config", "user.name", "Test"
    system "git", "config", "user.email", "test@example.com"
    system "git", "add", "test.txt"
    system "git", "commit", "-q", "--message='Test'"
    assert_match '"FullSemVer": "0.0.1-1"', shell_output("#{bin}/gitversion -output json")
  end
end
