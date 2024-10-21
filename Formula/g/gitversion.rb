class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/refs/tags/6.0.3.tar.gz"
  sha256 "a366c4d389bbca023da4ca2a214df91863acf58e939d7425ae7f31020560a5c2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1806492f1168477f56eff16cdc6498fe1443ccea6542a8852d9e5634115fa722"
    sha256 cellar: :any,                 arm64_sonoma:  "0f30d0e043f33345d99f134d01cd0c8f46d24387dd469f7f31174ac61116f6a1"
    sha256 cellar: :any,                 arm64_ventura: "1bd2a1d16bb3a77b6ac6e1a5b7d97334783ca801b640676520458269ebdbcdf2"
    sha256 cellar: :any,                 sonoma:        "48db4cb5ccda2db42ffc1977cc3c20fad1f85b4ae8f08e24c83229823ed9cb35"
    sha256 cellar: :any,                 ventura:       "f7d5f43b4ef7e5d37f39d8611353a8934ea94fef00a48501f33b14536f512cbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4d4a377267b3df42e79e60ff1a353ab2d8e5a6a1fa56a1e578e975527fec7fe"
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
