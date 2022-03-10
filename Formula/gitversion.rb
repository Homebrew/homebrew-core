class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.9.0.tar.gz"
  sha256 "ff67f91ed4ea5a208b9be37f9b52d76e20d3b8f63f5f6c407bf51a8c4f652446"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d920a0c9ae1322ef7de0cbe88a0a67b34acfeff19abc9569c4405a3c9d319061"
    sha256 cellar: :any,                 arm64_big_sur:  "d4e807ed7268f6b70493b49e98d5d4c79af7b50622d7e1362970341be09cbf90"
    sha256 cellar: :any,                 monterey:       "c70832a9c59c1b0c8fed72434ae8d75517c612a8f65c2ccb892d2f647b88d434"
    sha256 cellar: :any,                 big_sur:        "77a7ccdff16cdbe9bc97bb2507008aade43780147fa3ecb93ca78723b51941da"
    sha256 cellar: :any,                 catalina:       "2eabafaae6dbaa06f58617d1049388fc4d5113e1324ae948cc90bce1f8ca4b68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "102a4b40a448529506fcf40e689ad5853943d45bac6ed9f414f45e3298756512"
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
