class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.10.3.tar.gz"
  sha256 "3d0e1874b8037021db75cad22f49377f85e11d1590e760f4d7ba25dc93be3379"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "91095e6f53c0bdd790d33f4e6a058428da032406b9c75f9f0a027ddad022a172"
    sha256 cellar: :any,                 arm64_big_sur:  "f63fcfb138232512266b774a25c6bf233b527b1ac5bde899cf1d1706e15d9d53"
    sha256 cellar: :any,                 monterey:       "9587dee1b305b62cab5cf6343077ad8a30ddd45b254d9cbd57c474bd9b17076a"
    sha256 cellar: :any,                 big_sur:        "ca3c4923a8c5bf6d0a3f2a71179b37f64327126dad9e35f209e0d0fb4f617c05"
    sha256 cellar: :any,                 catalina:       "8001a610e6b58fe435ecbf82a6e071d500db30f7d3d9d6ec3101e637ba9c5d34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b00030ec01da55e3f9acb23bdea80893f9bb59dfa50ab64c8b3cda4a9b9cb63"
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
