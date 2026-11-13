class Cake < Formula
  desc "Cross platform build automation system with a C# DSL"
  homepage "https://cakebuild.net/"
  url "https://github.com/cake-build/cake/archive/refs/tags/v7.0.0.tar.gz"
  sha256 "91aecc5affe86993927d859f2d8c442fc0268ee229bdcf20c72829bea778e157"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "10d9c11dad1a5f67e2cb7fba77eb7e18a04559bdd5a3891868076d97bab7b163"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "af2ef0b8938b0c1865ccbeec6605d04e129ca7615dde2f074119f512076bf2eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "369eebbb28824d236d3153f20aff058daeaae056096d39c5ec38f6c804492af9"
    sha256 cellar: :any,                 arm64_linux:       "dfba519f5a2aed827898d8d4556f5609b0f98ae5ad7a94edcbcf948e1f648b40"
    sha256 cellar: :any,                 x86_64_linux:      "e25c0a91a368d87066629cf99c4bf71ca1f006307a79f6ebbdb591403910bc8c"
  end

  depends_on "dotnet"

  conflicts_with "coffeescript", because: "both install `cake` binaries"

  deny_network_access!

  def dotnet = deps.find { |d| d.name.match?(/^dotnet(@\d+)?$/) }.to_formula

  def fetch
    ENV["XDG_RUNTIME_DIR"] = buildpath
    system "dotnet", "restore", "src/Cake", "--use-current-runtime",
           "-p:TargetFrameworks=net#{dotnet.version.major_minor}"
  end

  def install
    ENV["XDG_RUNTIME_DIR"] = buildpath
    # Ignore dotnet version specification and use homebrew one
    rm "global.json"

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:AppHostRelativeDotNet=#{dotnet.opt_libexec.relative_path_from(libexec)}
      -p:TargetFrameworks=net#{dotnet.version.major_minor}
      -p:Version=#{version}
      -p:WarningsNotAsErrors=NU1902%3BNU1903
    ]

    system "dotnet", "publish", "src/Cake", *args
    bin.install_symlink libexec/"Cake" => "cake"
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
    assert_match "Hello Homebrew", shell_output("#{bin}/cake build.cake")
  end
end
