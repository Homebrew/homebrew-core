class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/refs/tags/6.1.0.tar.gz"
  sha256 "c4791cf3f3820606735e5cbb0bdb6bc1b2db6eedad485bab7d7ebef989228a94"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2a26219dd186253845ca6dd7c4190c30c0184875e9de7f091757adccfb6f5428"
    sha256 cellar: :any,                 arm64_sonoma:  "8451d1106918b8edbc6ae9d442afe9cca0b406830650c27ff010b677a8c42c28"
    sha256 cellar: :any,                 arm64_ventura: "2e8fdd8e17785052d544cf1f165d8409da23499238c4e6bf6fcf83f7665d5c19"
    sha256 cellar: :any,                 ventura:       "9e3ea5738e15a2a985f6251e8e6f9936d7d0aa8825caa4b1ac81eb03551eabd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0eb1171fd507667b3452053bb02c44c647991f2557f0fcf440441892bd63d298"
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
