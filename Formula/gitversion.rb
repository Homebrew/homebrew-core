class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  # TODO: Switch `dotnet@6` to `dotnet` with v6 release
  url "https://github.com/GitTools/GitVersion/archive/5.12.0.tar.gz"
  sha256 "fe2ecbd2d63a4458f19eb9f0ee6853b5041e8b2f6d7c75b0fa606be2d1a81476"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dab9486fded11ba18ab033fdca31afca9ff5aad0456ee48c40a65d87fc2dbadf"
    sha256 cellar: :any,                 arm64_monterey: "7aced285a32f399f6c216af712c0745655152ec21ac016cd697c006d8e65c375"
    sha256 cellar: :any,                 arm64_big_sur:  "8427313824f9cd563c5dd3271826484a28a0644694b59154e48157bda93b06b0"
    sha256 cellar: :any,                 ventura:        "5402d2a6acb294d9bb2ccbd029a9ecd5a44f7d0348ddfaee001fc1fc79b77067"
    sha256 cellar: :any,                 monterey:       "8d67d167194126c8e2d992e2eae39bb14acdb84f4a8bfd040949a603315a87ac"
    sha256 cellar: :any,                 big_sur:        "b2b362d2d07235f1bbbbfcb51cc7d2d1b531cf0238de565145cab3bfccbdddde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcb1a9e046e2542f7de19c4abdb49f21ca78e54c3c73480216c835826f880386"
  end

  depends_on "dotnet@6"

  def install
    dotnet = Formula["dotnet@6"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
      -p:PublishSingleFile=true
      -p:Version=#{version}
    ]
    args << "-p:OsxArm64=true" if OS.mac? && Hardware::CPU.arm?

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
    assert_match '"FullSemVer": "0.1.0+0"', shell_output("#{bin}/gitversion -output json")
  end
end
