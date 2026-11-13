class Fracturedjson < Formula
  desc "JSON formatter that produces highly readable but fairly compact output"
  homepage "https://github.com/j-brooke/FracturedJson"
  url "https://github.com/j-brooke/FracturedJson/archive/refs/tags/cli-v1.1.0.tar.gz"
  sha256 "0b6efec044f5c7d738f837124cdf5fc9d3b94864be8a9b07c2de8ffe22e2235a"
  license "MIT"

  livecheck do
    url :stable
    regex(/cli[._-]v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "86aaf461427214793d4dd980e9b7e1551056ee8a309c17e59aa22613aab4fb75"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c016d2004045b7295e0cb9b061eda412f51b0e6dba344f82954299b5e61b68bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a7d9fc03eb134805ebad5306bfc5df6478153b4fc9a820fdce1de529c45d8eaa"
    sha256 cellar: :any,                 arm64_linux:       "3d4986a30904cb6e67a77d3178e862bfa21bc0a561dbd4e2aa0c98257ec771ac"
    sha256 cellar: :any,                 x86_64_linux:      "6af75e8c10d4b66d06b16bf5f2c04d8eb73b1f115802f50d8959b788a339014f"
  end

  # Aligned to .NET dependency. Can remove if updated to latest .NET
  deprecate! date: "2026-11-12", because: "needs end-of-life .NET 8"
  disable! date: "2027-11-10", because: "needs end-of-life .NET 8"

  depends_on "dotnet@8"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    ENV["XDG_RUNTIME_DIR"] = buildpath
    system "dotnet", "restore", "Cli/Cli.csproj", "--use-current-runtime"
  end

  def install
    ENV["XDG_RUNTIME_DIR"] = buildpath

    dotnet = deps.find { |d| d.name.match? Version.formula_optionally_versioned_regex(:dotnet) }.to_formula
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --no-self-contained
      --output #{libexec}
      --property InvariantGlobalization=true
      --use-current-runtime
    ]
    system "dotnet", "publish", "Cli/Cli.csproj", *args
    (bin/"fracjson").write_env_script libexec/"fracjson", DOTNET_ROOT: dotnet.opt_libexec
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fracjson --version")

    input_json = <<~JSON
      {"BasicObject":{"ModuleId":"armor","Locations":[[11,2],[11,3],[11,4],[11,5],[11,6],[11,7],[11,8],[11,9],[11,10],[11,11],[11,12],[11,13],
      [11,14],[1,14],[1,13],[1,12],[1,11],[1,10],[1,9],[1,8],[1,7],[1,6],[1,5],[1,4],[1,3],[1,2],[4,2],[5,2],[6,2],[7,2]],"Seed":272691529},
      "SimilarArrays":{"Katherine":["blue","lightblue","black"],"Logan":["yellow","blue","black","red"],"Erik":["red","purple"]}}
    JSON
    output = pipe_output("#{bin}/fracjson", input_json, 0).chomp
    assert_operator output.lines.count, :>, 3
  end
end
