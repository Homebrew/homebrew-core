class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net/docs/"
  url "https://github.com/GitTools/GitVersion/archive/refs/tags/6.6.2.tar.gz"
  sha256 "762742f3ff65c3ceadf4520ed7cf8e8c42aa6bf40bd99c2e2754368ea0c1b207"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4c64d15f5af79bd4ba31c8afd4a18c8fa6a3be4a1331d4d6e88f6dab836d673e"
    sha256 cellar: :any,                 arm64_sequoia: "00763396739ed720a18ebec237d6230aeabffccd9d579a88806ef9471c772a27"
    sha256 cellar: :any,                 arm64_sonoma:  "2d5e353aa38618370ed47afdb6fd731d95e7a61afcaa0fe171c5470963949820"
    sha256 cellar: :any,                 sonoma:        "1f8d6a0ffda67d09d40fa8625df816e27c1eb366571811aa668bc9462f32d7e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "295f89da8184ff8387c2b03db6095c0ddc95b17306f8983e5d25232f762d6d50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f82d96e499d2c4447cc1cec9ef8ccde01c0edf69b5e90c01872fb99c8fbd0a6e"
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
