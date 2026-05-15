class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/archive/refs/tags/v2.78.5.tar.gz"
  sha256 "79f9e2c4bb8de2225d91a812a4e9d2cc71a8ed5613b3b4b2940d2a1d5db38793"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "523bb3a1bb69486ba96ed04a14cf5275a03eaee24666548664367c6ec751008b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4285f72a9207278e027124dacd47cfca73a31697f318a55699b27f5a0f586231"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2ea16f5a93cabc62e5206f4b58fc4962f7193502983909d8d8706ff1011153e"
    sha256 cellar: :any_skip_relocation, sonoma:        "74dd5ee74560f786debd8cbda5021834c5b2199b9890f385325de614f6be39be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef38f65f11a369979e4a188ba5677a49831eac7d2c5160f65b80bd324d8ea38c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f703a20bc12c55ae2083dadc0364892ee5aa0bec6b34c53aa2758fa48cd0d762"
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
