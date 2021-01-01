class ArchiSteamFarm < Formula
  desc "ASF is a C# application that allows you to farm steam cards"
  homepage "https://github.com/JustArchi/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm/releases/download/5.0.1.2/ASF-generic.zip"
  sha256 "b06f748fb59fa1db1b032830971788d17b95120787dfbe4863925fb4fd8a9f71"
  license "Apache-2.0"

  bottle :unneeded

  depends_on "mono"

  def install
    libexec.install "ASF.exe"
    (bin/"asf").write <<~EOS
      #!/bin/bash
      mono #{libexec}/ASF.exe "$@"
    EOS

    etc.install "config" => "asf"
    libexec.install_symlink etc/"asf" => "config"
  end

  def caveats
    <<~EOS
      Config: #{etc}/asf/
    EOS
  end

  test do
    assert_match "ASF V#{version}", shell_output("#{bin}/asf --client")
  end
end
