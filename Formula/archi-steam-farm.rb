class ArchiSteamFarm < Formula
  desc "ASF is a C# application that allows you to farm steam cards"
  homepage "https://github.com/JustArchi/ArchiSteamFarm"
  url "https://github.com/JustArchiNET/ArchiSteamFarm/archive/4.1.2.0.tar.gz"
  sha256 "7bc119fa386b665af8df98206c5bcfe99d8fe98bf48235a4e7c6c0de773bfab7"

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
