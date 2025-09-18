class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net/docs/"
  url "https://github.com/GitTools/GitVersion/archive/refs/tags/6.4.0.tar.gz"
  sha256 "d08e58a2b3910d02a3ce245624efd8803557c494e34d457943eb2fd92a651b2a"
  license "MIT"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9a6f1bbaf09eb8f883aea6f7aea8b01926de9daecfdbf18ce94aee8c514b3dfc"
    sha256 cellar: :any,                 arm64_sequoia: "53454f2d9a42e602926a6800c0fd2ebe166b6cf3d7416277b999ac7b5cb35b81"
    sha256 cellar: :any,                 arm64_sonoma:  "0b8caee11a1ac7587649a63185d08bd98857f4d77bfd803119ab729e1b601add"
    sha256 cellar: :any,                 arm64_ventura: "ff3615d7c99b1a300d62936871465f4c097a1e588cd42b2180f3b1c02359b12d"
    sha256 cellar: :any,                 ventura:       "98683b3e12ff6d7eb25f920b3b8cb9c1558b71058deca0b9b403801fcfa4cb0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "784cc729d23fbba5e7c6ac5e20b9303e32efc8307bbbaf1f3f14ca08c1bd8e4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f449450749fd275078b502c97472a1b3a7531f1152bde3fc0ab10c95475f541"
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
