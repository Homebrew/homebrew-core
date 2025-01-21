class Docfx < Formula
  desc "Tools for building and publishing API documentation for .NET projects"
  homepage "https://dotnet.github.io/docfx/"
  url "https://github.com/dotnet/docfx/archive/refs/tags/2.78.2.tar.gz"
  sha256 "0b0f53532fc887a1b7444d8c45f89d49250b6d26d8a24f8865563c4e916c1621"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bb8a82895b1ddb4721e6270e4f51e9c3e2e8d07f43c369fccb67a7efb6ea213"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e70aa4aa303dc525b97bccce9228e0a26d0268dd3046eae0785b4665812fb928"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75bf66e4af1da6da77ac5c25007082280340b8a40c142f81f56cb213acc6765f"
    sha256 cellar: :any_skip_relocation, ventura:       "189b92cafeaf9437f082c044a848830ee569ae69ce4c41843c522eb3608c62b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fad1e16707f9965f898ba6f8782aa79d1538ad0b87d48a0f2285703c1ed2ed4"
  end

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

    system "dotnet", "publish", "src/docfx", *args

    (bin/"docfx").write_env_script libexec/"docfx",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  test do
    system bin/"docfx", "init", "--yes", "--output", testpath/"docfx_project"
    assert_predicate testpath/"docfx_project/docfx.json", :exist?,
                     "Failed to generate project"
  end
end
