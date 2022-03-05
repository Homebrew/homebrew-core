class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.8.3.tar.gz"
  sha256 "7949e1b4ad10b2da48cfba9f4dc96f0902a192a2729c2d6ec606e2b63a7e5f96"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4ca629591a510cfc760afeb8648e24ac6887723afaa000ac05033e162ec57b05"
    sha256 cellar: :any,                 arm64_big_sur:  "5671968ccf82cf55309eae117c10266ca96777afcd7f42cec6221e59f8ceb4f8"
    sha256 cellar: :any,                 monterey:       "ad47c27b0cac76b5fcbd060e787d67fa434593bab2bed1b40591b8c87fce258e"
    sha256 cellar: :any,                 big_sur:        "058f61ceccde4b7b84d179a11080a7c1d4d6f8b20b294af1473943616aac5303"
    sha256 cellar: :any,                 catalina:       "0e2bf596fd60326f08cd4fb54dfe142d931b0d9dc1f79bb661d38638d98a9f8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93d8eb283b9b08134fb81ddf125c7d92e9a9860edbdeb14ad7fee7c8d11892a9"
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
