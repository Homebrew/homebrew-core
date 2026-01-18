class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net/docs/"
  url "https://github.com/GitTools/GitVersion/archive/refs/tags/6.5.1.tar.gz"
  sha256 "4a6ef13d01b949c953767188aab5f394d0a0b13ed926c1c91584d2d0cdf38b03"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "942a470f118b326107a6b3c702c514d05fa50e57fd51b6f472b325bcf93b35ef"
    sha256 cellar: :any,                 arm64_sequoia: "fcdd4dc3b2cd6de103045baf5e07e56ff0b8b46e4a20c7aa7bed9ec02fa3d2a6"
    sha256 cellar: :any,                 arm64_sonoma:  "bd96d2e19f8a8d999948c77097a021a905896b632cf4567f0aad1ca9fced3a51"
    sha256 cellar: :any,                 sonoma:        "15c4f6703ffbc8ad7f6e5ad19daeae2e608b82de5cd3575ae0f2892d672a9b1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ab18f5bf4377626a877cb5c52758e3ec3ec43ce4efef36e4d07b8ddc91fe366"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e6c4f74f405abc6729397b7afeba17ff235bbdd7f083ffc12311d6c9e24a16d"
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
    env["LD_LIBRARY_PATH"] = "#{Formula["openssl"].opt_lib}:$LD_LIBRARY_PATH" if OS.linux?
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
