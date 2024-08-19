class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/refs/tags/6.0.2.tar.gz"
  sha256 "e18aa3984c057efa6c6afdb223b31c9ea31f7859498ff84c02aaf6fc91d5c3a0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "28d46db8b669808fc430a0b958316e6faff23f150555119c7095cfd100ce334c"
    sha256 cellar: :any,                 arm64_ventura:  "33fc7543dfcec77c67c4759dd3c59b2d65b02d89df21fc1c2fea2d3646a651a4"
    sha256 cellar: :any,                 arm64_monterey: "36a19d0a3d5afee24bc6c503cde30201c932694dc8cfa8c29ea547621cea1490"
    sha256 cellar: :any,                 sonoma:         "eae0f7fff24077a8151ec40d1f23fa8a1033a56c593c8a9a7c0a84ce22382597"
    sha256 cellar: :any,                 ventura:        "b6d0372f81db453f2252977a07be5471f864697404259f2f231a7874de01b6fe"
    sha256 cellar: :any,                 monterey:       "d97f8ebb3eb0321f43808ac3814d2e52499d38c0e937491393546ff913e73390"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26b415bd114e91a473b65740f890722f6edc02b31d25f87547a77fbeaf7701af"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
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
