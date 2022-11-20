class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.11.1.tar.gz"
  sha256 "98ed28bfb22fadde72da412634f309d81030a76997ca998e1b34edc39beff489"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8d1dde8fde0eb649ccf639b0469090b6f7cf7daec5af586162be49b8ee3fbf9a"
    sha256 cellar: :any,                 arm64_monterey: "c8493e7cb21aca7c941744c8a22b1485a1615c33bbce998a59991968132883c5"
    sha256 cellar: :any,                 arm64_big_sur:  "b806eb80b7f7f4b81c69c56515c19149a06fe2b9b1e9753c22f54f6e6ff54745"
    sha256 cellar: :any,                 ventura:        "5371269e21bb25ddc5b760b270448e2acc494b79ae81af985b72f1c06e81cb25"
    sha256 cellar: :any,                 monterey:       "884e90c178d31d2441d17ca45154474cc0fe231f15df4e21a46486d9b768e85a"
    sha256 cellar: :any,                 big_sur:        "34b1dc9dff977fb3680786dd8600793c1e4ee5bd5ac9251362279e59a6265fe7"
    sha256 cellar: :any,                 catalina:       "975dbb602b2b4516df5028c5f270e2fdf96c4e2e4777eec37e2e1a9d39460a8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0a956ddf7ca501724e8a6335f54dcf47e931ec4d2585d71f483beb3f1609382"
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
