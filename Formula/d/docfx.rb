class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/archive/refs/tags/v2.81.0.tar.gz"
  sha256 "55b492cab70a7f883ea5e9a7a134a23d25d70e97153b61d1083ad6b5fa6e2d68"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "54c06778b7e7e7353fe4dae7788706b91435b7d4d2a4b4568180469d1b64272b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6cdc2af546d83db7ffecc8b5f22925955cea95f42afd8295a0005d2d06452c49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b2feeda22090cec9d3f438a867f5dcb6f13fc0ac887ab8217d12ac180a5f6cf5"
    sha256 cellar: :any,                 arm64_linux:       "8bb6ecc8e14a23814a8504c468d1c14270530c37a432b3156520e3100321c860"
    sha256 cellar: :any,                 x86_64_linux:      "9b8f56686249ceaa9bdc5a01a3ad4897ceb95be4edefa6959562bb6398948325"
  end

  depends_on "node" => :build
  depends_on "dotnet"

  deny_network_access!

  def dotnet = Formula["dotnet"]

  def fetch
    cd "templates" do
      system "npm", "ci", *std_npm_args(prefix: false)
    end
    system "dotnet", "restore", "src/docfx", "--use-current-runtime",
           "-p:TargetFrameworks=net#{dotnet.version.major_minor}"
  end

  def install
    # specify the target framework to only target the currently used version of
    # .NET, otherwise additional frameworks will be added due to this running
    # inside of GitHub Actions, for details see:
    # https://github.com/dotnet/docfx/blob/main/Directory.Build.props#L3-L5
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --no-restore
      --no-self-contained
      --output #{libexec}
      --use-current-runtime
      -p:AppHostRelativeDotNet=#{dotnet.opt_libexec.relative_path_from(libexec)}
      -p:Version=#{version}
      -p:TargetFrameworks=net#{dotnet.version.major_minor}
    ]

    cd "templates" do
      system "npm", "run", "build"
    end
    system "dotnet", "publish", "src/docfx", *args
    bin.install_symlink libexec/"docfx"
  end

  test do
    # The sandbox denies FSEvents, so .NET's config file watcher would hang
    ENV["DOTNET_USE_POLLING_FILE_WATCHER"] = "1" if OS.mac?

    system bin/"docfx", "init", "--yes", "--output", testpath/"docfx_project"
    assert_path_exists testpath/"docfx_project/docfx.json", "Failed to generate project"
    assert_match "modern", shell_output("#{bin}/docfx template list")
  end
end
