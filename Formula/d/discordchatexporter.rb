class Discordchatexporter < Formula
  desc "Saves Discord chat logs to a file"
  homepage "https://github.com/Tyrrrz/DiscordChatExporter"
  url "https://github.com/Tyrrrz/DiscordChatExporter/archive/refs/tags/2.48.tar.gz"
  sha256 "20f17e87cc01107adc072ca2f905c0e54dd51ccd5850b2bb99541ce939c4fc7d"
  license "MIT"

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]

    ENV["DOTNET_SKIP_FIRST_TIME_EXPERIENCE"] = "true"
    ENV["DOTNET_NOLOGO"] = "true"
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "true"

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --self-contained
      --use-current-runtime
      -p:Version=#{version}
      -p:DebugType=None
    ]

    system "dotnet", "publish", "DiscordChatExporter.Cli", *args
    (bin/"discordchatexporter").write_env_script libexec/"DiscordChatExporter.Cli",
    DOTNET_ROOT: formula_opt_libexec("dotnet")
  end

  test do
    assert shell_output("#{bin}/discordchatexporter export -t 12345 -c 12345", 1)
  end
end
