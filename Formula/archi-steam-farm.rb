class ArchiSteamFarm < Formula
  desc "ASF is a C# application that allows you to farm steam cards"
  homepage "https://github.com/JustArchi/ArchiSteamFarm"
  url "https://github.com/JustArchi/ArchiSteamFarm/releases/download/2.3.0.6/ASF.zip"
  version "2.3.0.6"
  sha256 "2f28fd5cd815b14ee278745be1a2e15a0cea6a2818b9be7a981edd1cd3e85ccb"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff52ca5cf441c28d3ee040048ce75cde101f087e8c350c5e3d0979bf28e0c535" => :sierra
    sha256 "ff52ca5cf441c28d3ee040048ce75cde101f087e8c350c5e3d0979bf28e0c535" => :el_capitan
    sha256 "ff52ca5cf441c28d3ee040048ce75cde101f087e8c350c5e3d0979bf28e0c535" => :yosemite
  end

  depends_on "mono"

  def install
    libexec.install "ASF.exe"
    (bin/"asf").write <<-EOS.undent
      #!/bin/bash
      mono #{libexec}/ASF.exe "$@"
    EOS

    etc.install "config" => "asf"
    libexec.install_symlink etc/"asf" => "config"
  end

  def caveats; <<-EOS.undent
    Config: #{etc}/asf/
    EOS
  end

  test do
    assert_match "ASF V#{version}", shell_output("#{bin}/asf --client")
  end
end
