class ArchiSteamFarm < Formula
  desc "ASF is a C# application that allows you to farm steam cards"
  homepage "https://github.com/JustArchi/ArchiSteamFarm"
  url "https://github.com/JustArchi/ArchiSteamFarm/releases/download/2.3.1.3/ASF.zip"
  version "2.3.1.3"
  sha256 "14157584c44b26bcfcc6df0e176747e77171cc0ed50baa5f52f4a3f78610ba96"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c77afdf025667c284ac48c18d74e96bd4c074ed1ccb5706b0721fa48491bcdf" => :sierra
    sha256 "4f6c5cde134fd92d8f89f4822c91f0f4c54a4408245aed51f66242795529b7a9" => :el_capitan
    sha256 "4f6c5cde134fd92d8f89f4822c91f0f4c54a4408245aed51f66242795529b7a9" => :yosemite
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
