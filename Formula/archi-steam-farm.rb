class ArchiSteamFarm < Formula
  desc "A C# (mono) application that allows you to farm steam cards using multiple steam accounts simultaneously."
  homepage "https://github.com/JustArchi/ArchiSteamFarm"
  url "https://github.com/JustArchi/ArchiSteamFarm/releases/download/3.0.5.5/ASF-osx-x64.zip"
  sha256 "4eab592ed6f7c389c071717a3aad1ba335c27edd9b7e8d06c9a34900b28c00ab"
  version "3.0.5.5"

  bottle :unneeded

  depends_on "mono"

  def install
    libexec.install Dir["*"]
    chmod 0755, Dir["#{libexec}/ArchiSteamFarm"]

    etc.install "#{libexec}/config" => "archi-steam-farm"
    libexec.install_symlink etc/"archi-steam-farm" => "config"
  end

  def caveats; <<~EOS
    Config: #{etc}/archi-steam-farm/

    You can also generate a configuration file via the web-based configurator here: 
    https://justarchi.github.io/ArchiSteamFarm/

    EOS
  end

  test do
    assert_match "ASF V#{version}", shell_output("#{bin}/ArchiSteamFarm --client")
  end
end
