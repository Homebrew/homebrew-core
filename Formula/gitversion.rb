class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.8.3.tar.gz"
  sha256 "7949e1b4ad10b2da48cfba9f4dc96f0902a192a2729c2d6ec606e2b63a7e5f96"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a719cf0fd89097469d948bbe2ef0aefa52e0ca879c50651e0557c62b51e8a3a9"
    sha256 cellar: :any,                 arm64_big_sur:  "f338f76a7cd793c3aaa607d2f9e5594509b19c1054acc079c53603c86d1281df"
    sha256 cellar: :any,                 monterey:       "f3fbd95a2f3a3556451f68a0f554836a5feee726fce586d2da00f9ba714db78a"
    sha256 cellar: :any,                 big_sur:        "2d7d3b2a4cb87325c3eb3c9564610594d28f28a94c73b59d350d70839078f571"
    sha256 cellar: :any,                 catalina:       "6011e70be306bdd9f4f8251898d2a7bae395b3e81e8aebfee1a75b6a682d677c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c97a8a9a991c4c628ac4402516b8b676e8c1d6d2cb7b4edde1c840791e903c76"
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
