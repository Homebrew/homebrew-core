class Discordchatexporter < Formula
  desc "Saves Discord chat logs to a file"
  homepage "https://github.com/Tyrrrz/DiscordChatExporter"
  url "https://github.com/Tyrrrz/DiscordChatExporter/archive/refs/tags/2.48.tar.gz"
  sha256 "20f17e87cc01107adc072ca2f905c0e54dd51ccd5850b2bb99541ce939c4fc7d"
  license "MIT"

  depends_on "dotnet"

  deny_network_access!

  def dotnet = deps.find { |d| d.name.match?(/^dotnet(@\d+)?$/) }.to_formula

  def fetch
    ENV["XDG_RUNTIME_DIR"] = buildpath
    system "dotnet", "restore", "DiscordChatExporter.Cli", "--use-current-runtime",
           "-p:TargetFramework=net#{dotnet.version.major_minor}"
  end

  def install
    ENV["XDG_RUNTIME_DIR"] = buildpath

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
      -p:AppHostRelativeDotNet=#{dotnet.opt_libexec.relative_path_from(libexec)}
      -p:PublishTrimmed=false
      -p:TargetFramework=net#{dotnet.version.major_minor}
      -p:Version=#{version}
    ]

    system "dotnet", "publish", "DiscordChatExporter.Cli", *args
    bin.install_symlink libexec/"DiscordChatExporter.Cli" => "discordchatexporter"
  end

  test do
    assert_match "To get the token for your personal account", shell_output("#{bin}/discordchatexporter guide")
  end
end
