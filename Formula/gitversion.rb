class Gitversion < Formula
  desc "Easy semantic versioning for projects using Git"
  homepage "https://gitversion.net"
  url "https://github.com/GitTools/GitVersion/archive/5.10.3.tar.gz"
  sha256 "3d0e1874b8037021db75cad22f49377f85e11d1590e760f4d7ba25dc93be3379"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b2bc2ef9fffbe28ac0e414dc336307923d49543e3fb0ce1cb66570316bb7f454"
    sha256 cellar: :any,                 arm64_big_sur:  "33b36531b1a95635569fbe7c2ccef5ba416b7b4d9f8b1d5ccd9fee8b3b763cac"
    sha256 cellar: :any,                 monterey:       "23d33a88fee71ff005f31c1c4f088750b7e7668c33606c9d15da8756120c64ff"
    sha256 cellar: :any,                 big_sur:        "506884a0fd68dff3e8c39cc0147706fe47965d92427431c7ab29f3267e050d0f"
    sha256 cellar: :any,                 catalina:       "b484acb9c7cf18b95aa27f7e60759db69b709e8269fe44f05c3321b32e3673c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c4d34611fb891fa380c4cbfaf25445a091595c647cbb38e250db14bd14abff6"
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
