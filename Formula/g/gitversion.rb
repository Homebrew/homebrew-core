class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net/docs/"
  url "https://github.com/GitTools/GitVersion/archive/refs/tags/6.8.1.tar.gz"
  sha256 "62f8a0c075e0ddda911c2a130d24421f77bd94cf41026ff9fb19aa446aa19142"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9b61a891f7d99ef2903141e77515cea4931c28ca53a11903d6e828a57e9808d8"
    sha256 cellar: :any, arm64_sequoia: "f8ae5b3f4e2511582f05c8d5c466b8d6dd7ac79b698f586428ee3938ffa2b9f8"
    sha256 cellar: :any, arm64_sonoma:  "b142d61cdec8852cf25bbe7aa75fe3c32a1d199802806afdede866cfa4ab353b"
    sha256 cellar: :any, sonoma:        "993063e8e941b82224716d99adc048ee2649d07af6d1409812889fcec7265101"
    sha256 cellar: :any, arm64_linux:   "8dce6f939b0ce7018221e7a4a38cdc8e9427f6eaefc4611ad12b637a2837a1ce"
    sha256 cellar: :any, x86_64_linux:  "aa251441673261dd5f5e3e440b0bf9489d9f794fa80fe6d531282c7c8488b784"
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
