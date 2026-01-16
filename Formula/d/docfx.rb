class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/archive/refs/tags/v2.78.4.tar.gz"
  sha256 "255f71f4a6fc7b9ffd0c598d0eba11630dc01262f1fa45ec4f1794508f7033cf"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e2aa098788350e0ade470448132aaea0606cd12696fc3067c379f0d2a8c1ed8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c44b39e9d561d333cb41db6d268bba9d7f77ac6db339fce1c7af42c8412404d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "618cc85be0dae390ec7bb4b28c7e4aeb14037e35dd6cf5233de5ee70e01a750a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03bd4f3996e6a3b9ba86d77ecc8edec829ff967c9c633b88e5ac82ee28e097c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c36e01983226081a6660535b0314e43930cb49af39a2280bed57b5a19fac3da1"
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
