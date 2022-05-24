class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.10.1.tar.gz"
  sha256 "3e65444ef3c017187d5f16f3d43f7ea07eec9bce9e73d69438e893136a8136be"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e4b5f35ac7c8a3849f216a44d94deee0f7e4e6ec1b4dd4be0bf6dea29bd1fc25"
    sha256 cellar: :any,                 arm64_big_sur:  "b8a8f5da513769bf0a24fdfec3096627711df2529e163e6c09754c20119b37c8"
    sha256 cellar: :any,                 monterey:       "41d255127c87ae0e230504a1c8566b23b48c9da159f45d98e3b5e31cab677c66"
    sha256 cellar: :any,                 big_sur:        "d129b46619dd7beec3998f535b75a14bbc830e0c5bfd23f8045fdb542b9c1678"
    sha256 cellar: :any,                 catalina:       "a06a65c57f86567757fe58e96c31f9771dd9c370db4b0189f8f0582532ed0da4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b9f5183e6b87a58ea902a44881b1ff9795faa5609b862b13ae1bc5836934cc5"
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
