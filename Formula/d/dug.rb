class Dug < Formula
  desc "Global DNS propagation checker that gives pretty output"
  homepage "https://dug.unfrl.com"
  url "https://github.com/unfrl/dug/archive/refs/tags/0.0.100.tar.gz"
  sha256 "bc7df36788cc4bb1ee01cfbaa670e4f8f97280d1906710360b5702764dcbda28"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "196ecc1a710beb5353c86d725cdfa6b85e7d5e77944c2471f1eb5c968739f053"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "962ec5aaf7431c9b43562dd54615b68ba1afb569856ca78142200c43eb310870"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0f0a47a7a0e8b2de0cf945c3e762dca3d1bf45cbfb300ca02277ace6eb2afe8c"
    sha256 cellar: :any,                 arm64_linux:       "5d250e69cf65d7df01d5cce51a250d0ea2623a887d2ee15ba8fdde43099637ad"
    sha256 cellar: :any,                 x86_64_linux:      "1cb00b2307b6d4870108e11471008b31cbbada2d67eede004aca79c49aec5503"
  end

  depends_on "dotnet@10"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def dotnet = deps.find { |d| d.name.match?(/^dotnet(@\d+)?$/) }.to_formula

  def fetch
    ENV["XDG_RUNTIME_DIR"] = buildpath
    system "dotnet", "restore", "cli/dug.csproj", "--use-current-runtime",
           "-p:TargetFrameworks=net#{dotnet.version.major_minor}"
  end

  def install
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"
    ENV["XDG_RUNTIME_DIR"] = buildpath

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --no-self-contained
      --output #{bin}
      --use-current-runtime
      -p:AppHostRelativeDotNet=#{dotnet.opt_libexec.relative_path_from(bin)}
      -p:TargetFrameworks=net#{dotnet.version.major_minor}
      -p:Version=#{version}
      -p:PublishSingleFile=true
      -p:IncludeNativeLibrariesForSelfExtract=true
      -p:DebugType=None
    ]

    system "dotnet", "publish", "cli/dug.csproj", *args
  end

  test do
    system bin/"dug", "google.com"

    assert_match version.to_s, shell_output("#{bin}/dug --version")
  end
end
