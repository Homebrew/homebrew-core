class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/archive/refs/tags/v2.78.3.tar.gz"
  sha256 "d97142ff71bd84e200e6d121f09f57d28379a0c9d12cb58f23badad22cc5c1b7"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abb66975d8752e67e031dd9f7a29bf6c3e896f5b424815d5dc088436ecfd8a40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f97bed8a6dde6e7a73af444d845a63027029dc9dcb604177f166c712dc871d7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "063a6dc7fb65e9d026503301fe0fe7b840d2e08b22015cb72773a9f7d92e4089"
    sha256 cellar: :any_skip_relocation, ventura:       "b1792841cb03d32d705e997d97ce7cc5a1e92ed3293de92b84d7055c7cdc5d2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c965e56932c64b38e3321027a5252e9ef6ca06aa8464e8d11def4b3cff09a609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41d6acfb56f458d4113e56c3a4b3368a29247d8ad4cf2caea98d2d7583fe38c8"
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
    system bin/"docfx", "init", "--yes", "--output", testpath/"docfx_project"
    assert_path_exists testpath/"docfx_project/docfx.json", "Failed to generate project"
    assert_match "modern", shell_output("#{bin}/docfx template list")
  end
end
