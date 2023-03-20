class Cake < Formula
  desc "Cross platform build automation system with a C# DSL"
  homepage "https://cakebuild.net/"
  url "https://github.com/cake-build/cake/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "2bd3f55d13e559120296aa206ebe09f0410ccd6f133dd1bcb90f56470bfcf09e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbb05c3469ebbc09371e1d718dfb778200f703fc1c53bc396f89548ffc7cd548"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "461c9577cc5c6259300acb11754c3a7ac96d93dbe138046d2ae278fe7ce23d4b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23c07c321306938f0f2646eda74581b0760eea2bcc442049f25edbcfcc984830"
    sha256 cellar: :any_skip_relocation, ventura:        "09047ccfdc00726c3fa3dd218907ee21d835b6d4b23f625b5da8e5bf2fd11556"
    sha256 cellar: :any_skip_relocation, monterey:       "ff1d7318bcc39206aea75063be39cbf2b924da3e2be8ea21834312ded7ecae1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa889b18b3ce98e02e27a2ab5a2a7ced8a420a6ef7d7490dab02449929732812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3fda2e3c37cbad6ae0e407291e5447857dbc36359500be831b34b19a673679c"
  end

  depends_on "dotnet"

  conflicts_with "coffeescript", because: "both install `cake` binaries"

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
      /p:Version=#{version}
    ]

    system "dotnet", "publish", "src/Cake", *args
    env = { DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}" }
    (bin/"cake").write_env_script libexec/"Cake", env
  end

  test do
    (testpath/"build.cake").write <<~EOS
      var target = Argument ("target", "info");

      Task("info").Does(() =>
      {
        Information ("Hello Homebrew");
      });

      RunTarget ("info");
    EOS
    assert_match "Hello Homebrew\n", shell_output("#{bin}/cake build.cake")
  end
end
