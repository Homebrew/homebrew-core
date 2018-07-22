class ArchiSteamFarm < Formula
  desc "ASF is a C# application that allows you to farm steam cards"
  homepage "https://github.com/JustArchi/ArchiSteamFarm"
  url "https://github.com/JustArchi/ArchiSteamFarm/releases/download/2.3.2.0/ASF.zip"
  sha256 "1a9f50c3cf2eb00e5148bc21a209b0c7c275b6c36c8cae8b4d9b2469bee7ff33"

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

  def caveats; <<~EOS
    Config: #{etc}/asf/
  EOS
  end

  test do
    assert_match "ASF V#{version}", shell_output("#{bin}/asf --client")
  end
end
