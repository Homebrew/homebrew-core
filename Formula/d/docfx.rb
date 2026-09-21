class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/archive/refs/tags/v2.80.1.tar.gz"
  sha256 "89607eba1d832063bccbe1be365d88ddec9ee90f3098e8081f9ba922c6916baf"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "69b42d70f57aaa3b00c70ac516ae6ec606b6633aa0c0f5dfbf42c7cb369e0792"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "68d52e254e90a6af67a80f9e8b5adb42e661ed47c8d83bd8add8cff7d78b1cf4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "910204c1488929c80d6c72341f2b82db10743d764df5c78bb0dd8f91a4552fac"
    sha256 cellar: :any,                 arm64_linux:       "c9a00da37456181ce55eea257eebffc5110be21fe7a4fb5ec9ff682b488ea823"
    sha256 cellar: :any,                 x86_64_linux:      "4d18cd290abb9f49365eef4ca59192e74250c1d45806fd57bade431ef4bf2107"
  end

  depends_on "node" => :build
  depends_on "dotnet"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"

    dotnet = Formula["dotnet"]

    # specify the target framework to only target the currently used version of
    # .NET, otherwise additional frameworks will be added due to this running
    # inside of GitHub Actions, for details see:
    # https://github.com/dotnet/docfx/blob/main/Directory.Build.props#L3-L5
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:Version=#{version}
      -p:TargetFrameworks=net#{dotnet.version.major_minor}
    ]

    cd "templates" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end
    system "dotnet", "publish", "src/docfx", *args

    (bin/"docfx").write_env_script libexec/"docfx",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  test do
    # The sandbox denies FSEvents, so .NET's config file watcher would hang
    ENV["DOTNET_USE_POLLING_FILE_WATCHER"] = "1" if OS.mac?

    system bin/"docfx", "init", "--yes", "--output", testpath/"docfx_project"
    assert_path_exists testpath/"docfx_project/docfx.json", "Failed to generate project"
    assert_match "modern", shell_output("#{bin}/docfx template list")
  end
end
