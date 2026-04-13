class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net/docs/"
  url "https://github.com/GitTools/GitVersion/archive/refs/tags/6.7.0.tar.gz"
  sha256 "8e1dc9d5d1a3dd0458893f18cd9d0890d069f3d19126977fdac738ace39a7747"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bbfe0b04de824a2194d870db449fb42678a81e7476a28bb8e973ac179ff7fa6e"
    sha256 cellar: :any,                 arm64_sequoia: "80b8d5e429bfff54917e3de8996ec80d7eb72a2f5b1cac60f7246d450d538500"
    sha256 cellar: :any,                 arm64_sonoma:  "053005c2bfab0bbb2358b5b5ac4a1fe62f268b16d0a4576efbcc71a82322944f"
    sha256 cellar: :any,                 sonoma:        "424f3fd7d9716e4ee6b1eb695c234fddcfa7eed1928b61652c99eb1640fb01ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a4c45fc6bb92cbdbbb0d6d7727bd767a931f8fed8edcba087ec3f9b0595f94d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8af97fe84db6f4dc3c9a436646af2eba1bb2575995bbd095a3338a16739caa6d"
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
