class Ckan < Formula
  desc "Comprehensive Kerbal Archive Network"
  homepage "https://github.com/KSP-CKAN/CKAN/"
  url "https://github.com/KSP-CKAN/CKAN/archive/refs/tags/v1.36.4.tar.gz"
  sha256 "5b7d4257ccd760b809cd75a6b2b7bfb2fcf42c8bd492d6c1b61b04e7649b2aaf"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e82842b138c68f3bf99c799358d0a99453f558c2196c41172835b7ed76d1bfbf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ec6124396ab9a00b540e0b925643213a50be95c54b365f98247959622a0fd825"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ef595601d00d07c7f0d4f765583a804e532f1336059e23b8eba6db18ef0addb1"
    sha256 cellar: :any,                 arm64_linux:       "3135db5229dac64223fbeb1219db3d3e36c762dd85ace11b9a40937f2c377c35"
    sha256 cellar: :any,                 x86_64_linux:      "a5e4c28ebc6392e72117889d138fca22c59bc0d6fcda3853120c29ed94b12008"
  end

  depends_on "dotnet@10"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    # .NET's user-scoped named mutexes need a writable runtime directory on Linux.
    ENV["XDG_RUNTIME_DIR"] = buildpath

    dotnet = deps.find { |d| d.name.match? Version.formula_optionally_versioned_regex(:dotnet) }.to_formula
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --no-self-contained
      --output #{libexec}
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
