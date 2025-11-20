class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net/docs/"
  url "https://github.com/GitTools/GitVersion/archive/refs/tags/6.5.0.tar.gz"
  sha256 "28a3ee76ae3a4f7cd035e6f3b4d458bbcc82ea757fe91d6563e969416f66027f"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f52db0fc4ce219eadce847fc615696550e18c3a7f891163a4318d2512043c326"
    sha256 cellar: :any,                 arm64_sequoia: "9cf44b3860130862cdbc7eca12640169319f3d468f5063cad4f5100ee653ff32"
    sha256 cellar: :any,                 arm64_sonoma:  "fe3371a0819227415ac80423ae97edcd57ec8ef67f6bb52cc039a12a9c0a0da0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57f7c2dcd3f478941eb63c563366d0b00c8e5798a0542058b923e50340a0b575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08a1e2b8d1da9dec483ba02748783f86f4e6fffcb97d69288aa313012b04d959"
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
