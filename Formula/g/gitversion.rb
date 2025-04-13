class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net/docs/"
  url "https://github.com/GitTools/GitVersion/archive/refs/tags/6.2.0.tar.gz"
  sha256 "ae06e4311555dd37261caa33fb6b91937021e3244872176bf72878c7e557f756"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4c675a69481803eb0bd52627f6113d3ddb485408093ed29fdf40eea065b44613"
    sha256 cellar: :any,                 arm64_sonoma:  "ce8c2233bc77c507bd57079944aae4591dae99dbfc212cf63e5108d37cfd20f6"
    sha256 cellar: :any,                 arm64_ventura: "f0b5e913f2af7f6082b45fc6220013c84dc8f94a5d98970d0238f2946493950b"
    sha256 cellar: :any,                 ventura:       "53a92ff1948bc9bb2aaecfa05dfa639e4651c7d7b10b49972783313a9777656d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "484c0bca8a5b6c2eb0c8f814800ceb5da3ad32026ca08df95b17471e5d5aa1e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "789dc54fadc6d5dec0e2d9339855a1f6fd6bd4c7bdd2583acded892b502a6c21"
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
