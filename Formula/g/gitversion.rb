class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net/docs/"
  url "https://github.com/GitTools/GitVersion/archive/refs/tags/6.8.2.tar.gz"
  sha256 "02b7efc0b9cfee26971c0f89b27724eb51d33c3230788963e77dc94070173c21"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2125213b57952276cb8061484e008859ad0657a8bba56dd312ec6400c771b482"
    sha256 cellar: :any, arm64_sequoia: "0bf4cd2cd05aba7af483e41ff29468133f2a94a98fb1a74d5750252cc61ec285"
    sha256 cellar: :any, arm64_sonoma:  "e3508fdfa8135122614d0ac7cb5facc9adab96253ca742f60d31b25a1092d257"
    sha256 cellar: :any, sonoma:        "595228141204dfb9ee0c78852290f8c8bae44fc776e308d7f6702a61b48769c0"
    sha256 cellar: :any, arm64_linux:   "bf2329ef9f28eda35385d77f101d0c4ac475b6d7d8894a05f8685cc032bf9d48"
    sha256 cellar: :any, x86_64_linux:  "caf15de5aeb5ed923dfff139899257411c0eb81fa5435ee28750ba1544130a96"
  end

  depends_on "dotnet"
  depends_on "openssl@3"

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
    # Ensure OpenSSL is available for cryptography operations on Linux
    env["LD_LIBRARY_PATH"] = "#{formula_opt_lib("openssl")}:$LD_LIBRARY_PATH" if OS.linux?
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
