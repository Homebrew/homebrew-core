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

  depends_on "dotnet"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"

    dotnet = Formula["dotnet"]
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
    ENV["CKAN_CONFIG_FILE"] = testpath/"config.json"
    assert_match version.to_s, shell_output("#{bin}/ckan version")

    output = shell_output("#{bin}/ckan update", 1)
    assert_match "I don't know where a game instance is installed", output
  end
end
