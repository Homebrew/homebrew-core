class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.8.2.tar.gz"
  sha256 "6a257db2f33cd2a14ffa38f22c35f42473d52810ee4c2be3560abe5458f477a7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "476cbc76c69777456537b11d08044c896aada8b658523e771082095b70087de6"
    sha256 cellar: :any,                 arm64_big_sur:  "185ad5a268d07c03b1ea6dde0b38be57ea7bafdf8e84e5626d3fc61edfa9763e"
    sha256 cellar: :any,                 monterey:       "dda1da1aeeaa5636493bc80a17263e5a8816a476b33661c7326422d27e69beb1"
    sha256 cellar: :any,                 big_sur:        "5162d8ade4eecc0e4d35f4907a28942b0a2bcfbbcc73e65f500cb17fd49cebcf"
    sha256 cellar: :any,                 catalina:       "0b00bd24212432502ddb04b1a04f98c6ee055056744cb20a253ee6b349aae894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b803214f62636fcd0fe455f5f6c0587124679e377b53486763d9322c7948b80"
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
