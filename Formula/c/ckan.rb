class Ckan < Formula
  desc "Comprehensive Kerbal Archive Network"
  homepage "https://github.com/KSP-CKAN/CKAN/"
  url "https://github.com/KSP-CKAN/CKAN/archive/refs/tags/v1.36.4.tar.gz"
  sha256 "5b7d4257ccd760b809cd75a6b2b7bfb2fcf42c8bd492d6c1b61b04e7649b2aaf"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8d58c9014f39a3e847cc0feea02a216b13c9aa5ef77036686f80d131ec2389f4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dffad48ff1aaadcb51aa576f692df0b79476e6a914b7eec5234afceb2614198a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "49a0e9dfbc380cafacd0fd2b5bf714f4f4dd94f93a7f4800e376913525018a9e"
    sha256 cellar: :any,                 arm64_linux:       "ec6e13e5494f3fc369897206f024ebe87575c4797b285a6189d138bf0feec742"
    sha256 cellar: :any,                 x86_64_linux:      "f997195e4880fb61ce3f592c41ec09f83e417381ebc0e2d0a0e967b065c81904"
  end

  depends_on "dotnet"

  allow_network_access! :test

  def dotnet = deps.find { |d| d.name.match?(/^dotnet(@\d+)?$/) }.to_formula

  def fetch
    ENV["XDG_RUNTIME_DIR"] = buildpath
    system "dotnet", "restore", "Cmdline/CKAN-cmdline.csproj", "--use-current-runtime",
           "-p:TargetFrameworks=net#{dotnet.version.major_minor}"
  end

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["XDG_RUNTIME_DIR"] = buildpath

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:AppHostRelativeDotNet=#{dotnet.opt_libexec.relative_path_from(libexec)}
    ]

    system "dotnet", "publish", "Cmdline/CKAN-cmdline.csproj", *args
    bin.install_symlink libexec/"CKAN-CmdLine" => "ckan"
  end

  def caveats
    on_macos do
      <<~EOS
        If upgrading from a prior Mono-based install, you may want to migrate your
        appdata in "$HOME/.local/share/CKAN" to "$HOME/Library/Application Support/CKAN"
      EOS
    end
  end

  test do
    # On macOS .NET uses NSApplicationSupportDirectory which does not support $HOME.
    # Thus CKAN is expected to fail within sandboxed test when run for first time.
    if OS.mac?
      assert_match "Library/Application Support/CKAN' is denied.", pipe_output("#{bin}/ckan version 2>&1")
      return
    end

    assert_match version.to_s, shell_output("#{bin}/ckan version")

    output = shell_output("#{bin}/ckan update", 1)
    assert_match "I don't know where a game instance is installed", output
  end
end
