class Discordchatexporter < Formula
  desc "Saves Discord chat logs to a file"
  homepage "https://github.com/Tyrrrz/DiscordChatExporter"
  url "https://github.com/Tyrrrz/DiscordChatExporter/archive/refs/tags/2.48.tar.gz"
  sha256 "20f17e87cc01107adc072ca2f905c0e54dd51ccd5850b2bb99541ce939c4fc7d"
  license "MIT"

  bottle do
    manifest_sha256 "edb67b7ccb5f170a58727943cc336ecc32c3a0c4d2c3b14c7fc8a1dc9aca767a"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f3c47834094eb8ca8d1e188029f0c27a5bd2ca29b3f78b2e85bfce178f8b090e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b570218170b813f4422d0d4ecfb3fe57b325d28bd234bc802ae7d5bf74c129ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4697a1a631c5a52bd26af16932c0863ca5dc31f8f7ee751345933d4df2e1de64"
    sha256 cellar: :any,                 arm64_linux:       "32f93919781664c25d5768190d47ff3e7624e36778c69185724bf203f7e104a9"
    sha256 cellar: :any,                 x86_64_linux:      "175d6228be59f6497f092c8b57fe1d50caeef1f21f4138448d90bc94418120b5"
  end

  depends_on "dotnet@10"

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
    assert_match version.to_s, shell_output("#{bin}/discordchatexporter --version")
    assert_match "To get the token for your personal account", shell_output("#{bin}/discordchatexporter guide")
  end
end
