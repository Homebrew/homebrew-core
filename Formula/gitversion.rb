class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.10.1.tar.gz"
  sha256 "3e65444ef3c017187d5f16f3d43f7ea07eec9bce9e73d69438e893136a8136be"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "129dca35da824f7fd8d446b9110d10a3a35e43aebca25c8d61399a24e5c01d0e"
    sha256 cellar: :any,                 arm64_big_sur:  "7d7ba6fdf382c2e6aec39226bfd95cca78c1f727ababebde114b276b7cd696ba"
    sha256 cellar: :any,                 monterey:       "7672d353d0246212afd5fadaa6e028427e95b637e8c7874c4ebbd7dd563c6eae"
    sha256 cellar: :any,                 big_sur:        "b306a7bdc0b84ff9d753b2344ade5ba4c940ae8e717947a57f6ca8946de94e2f"
    sha256 cellar: :any,                 catalina:       "cf73cb00dd3d3ac041ddf9c3dbe11cb064f041265abc987ab622d908860f15a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e029e613595654e3483a3540c46236061617a7d2014bf8b6d736ad8586fd3499"
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
