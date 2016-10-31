class ArchiSteamFarm < Formula
  desc "ASF is a C# application that allows you to farm steam cards"
  homepage "https://github.com/JustArchi/ArchiSteamFarm"
  url "https://github.com/JustArchi/ArchiSteamFarm/releases/download/2.1.6.3/ASF.zip"
  version "2.1.6.3"
  sha256 "62671db765e06f959b007a97f9bd9ad2cb5521c849aef81d8a48f5d2cee52b5a"

  bottle do
    cellar :any_skip_relocation
    sha256 "36fdcf06afafa3fbb35ce505ee619414b3ce284ab8a7779018b2b691a63c49fc" => :sierra
    sha256 "36fdcf06afafa3fbb35ce505ee619414b3ce284ab8a7779018b2b691a63c49fc" => :el_capitan
    sha256 "36fdcf06afafa3fbb35ce505ee619414b3ce284ab8a7779018b2b691a63c49fc" => :yosemite
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
