class ArchiSteamFarm < Formula
  desc "ASF is a C# application that allows you to farm steam cards"
  homepage "https://github.com/JustArchi/ArchiSteamFarm"
  url "https://github.com/JustArchi/ArchiSteamFarm/releases/download/2.3.1.3/ASF.zip"
  version "2.3.1.3"
  sha256 "14157584c44b26bcfcc6df0e176747e77171cc0ed50baa5f52f4a3f78610ba96"

  bottle do
    cellar :any_skip_relocation
    sha256 "201d45202e65f16b145672ad29ec12ee03d66cbea1024e413fa4bc77ed51e577" => :sierra
    sha256 "0bd29bcc65c52a3cd45b26134e867e9e44bb318e9a624a1cb344e21ddfec1a7f" => :el_capitan
    sha256 "0bd29bcc65c52a3cd45b26134e867e9e44bb318e9a624a1cb344e21ddfec1a7f" => :yosemite
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
