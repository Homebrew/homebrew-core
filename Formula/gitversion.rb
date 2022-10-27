class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.10.3.tar.gz"
  sha256 "3d0e1874b8037021db75cad22f49377f85e11d1590e760f4d7ba25dc93be3379"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "884486e4221dfebbb2663882c4389583b25b682e1fb793fa1a149129c71260a1"
    sha256 cellar: :any,                 arm64_monterey: "04b4027f2fad95d6e91b1e7e397861152c0725b8df6d19c04c1c82789869aae1"
    sha256 cellar: :any,                 arm64_big_sur:  "9f15edcfcc9719428c29c9545a2e935aca93565ca4502c5bb82a691fd0a26bf7"
    sha256 cellar: :any,                 monterey:       "fae0b0d5478bc07e79008dccca8b4e118e886fa4d52870f39ed749cb864ec776"
    sha256 cellar: :any,                 big_sur:        "afb41b78c0726b14b47010f6f2e3c7eb4ef08162e5fbd609e5b77106a3ae7a1f"
    sha256 cellar: :any,                 catalina:       "0ec9a03a2f37981cffcbdf91cb78e4de1d3ca2e2af94cfb3749766d4dae79696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7866bb8885b5e732d6e93543f2b6ff806cf46660c99e8d3592c38b204a10ebaa"
  end

  depends_on "dotnet"

  def install
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{Formula["dotnet"].version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
      -p:PublishSingleFile=true
      -p:Version=#{version}
    ]
    args << "-p:OsxArm64=true" if OS.mac? && Hardware::CPU.arm?

    system "dotnet", "publish", "src/GitVersion.App/GitVersion.App.csproj", *args
    env = { DOTNET_ROOT: "${DOTNET_ROOT:-#{Formula["dotnet"].opt_libexec}}" }
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
    assert_match '"FullSemVer": "0.1.0+0"', shell_output("#{bin}/gitversion -output json")
  end
end
