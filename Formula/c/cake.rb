class Cake < Formula
  desc "Cross platform build automation system with a C# DSL"
  homepage "https://cakebuild.net/"
  url "https://github.com/cake-build/cake/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "ea45d7a69f7bc373bd4d38ed708632a4ff7365d36cb9a85c40a107e6a7ae2c1b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9b93e9b43a600ac1b2c4f1a208bd3d32351e9479a32798f03a3f3240c3048ba7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e14ff691a1afc175e118455606320bd182fba32098c84c2b0e608216ea0ae90"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5a7244265a5d8de77aaf286582825e14a0922f45233b72b190f597b552ea520"
    sha256 cellar: :any_skip_relocation, sonoma:         "20b640ab1211cb2414ea3afd61b66358457eeb907f305ba2752c7d017aa323fc"
    sha256 cellar: :any_skip_relocation, ventura:        "0f5b7483f521a47e7d8263812410cb440b7281e6178775eab0e2704384b64695"
    sha256 cellar: :any_skip_relocation, monterey:       "aaf5ebc10b59cd8bd82a0ca457c969ff742d94ff607623898f6c1953ee8df542"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30b72806f212766992de3f8e262c70b086542cf1441104ec1105fd9c41ba9d8b"
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
