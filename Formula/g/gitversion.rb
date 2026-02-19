class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net/docs/"
  url "https://github.com/GitTools/GitVersion/archive/refs/tags/6.6.0.tar.gz"
  sha256 "51f35533fff4d3dde0167b903a4234b4c492063415eb3e740c8b87c9555a696b"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fe59b7e11dd63f56dcc65321daede76adb71cd05c0d707922e83efaaf394e637"
    sha256 cellar: :any,                 arm64_sequoia: "657b6236e4608e629a04cc4858c854f8342856696bd6a0361f8323a9e9080a3a"
    sha256 cellar: :any,                 arm64_sonoma:  "29fe2851ca638961ebf950441d248641a130f56eb1122e35920a8008c5ffbda2"
    sha256 cellar: :any,                 sonoma:        "1ce35e6402de57622f9fd367e765fa60280edb182e728006fce4f6d34683c075"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "518958dd8f395c8a07b043cc7f3e6d88d3bccda42a3c6ba0ace0dfbe09773e77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72f5ac7d942bea01562ebf0eb2ff9393a0ed9f117376331ed6a266b32882a0da"
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
