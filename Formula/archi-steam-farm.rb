class ArchiSteamFarm < Formula
  desc "ASF is a C# application that allows you to farm steam cards"
  homepage "https://github.com/JustArchi/ArchiSteamFarm"
  url "https://github.com/JustArchi/ArchiSteamFarm/releases/download/2.1.6.2/ASF.zip"
  sha256 "b7670ae84d08b2512b823bc820870b14c8810297f5f526b5b785fde8ee6b67f6"

  bottle do
    cellar :any_skip_relocation
    sha256 "bcd7bfabc46251ab44e9d912185f2f782d4bfcf6125b6e68be2fc285061cc4ad" => :sierra
    sha256 "bcd7bfabc46251ab44e9d912185f2f782d4bfcf6125b6e68be2fc285061cc4ad" => :el_capitan
    sha256 "bcd7bfabc46251ab44e9d912185f2f782d4bfcf6125b6e68be2fc285061cc4ad" => :yosemite
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

  test do
    assert_match "ASF V#{version}", shell_output("#{bin}/asf --client")
  end
end
