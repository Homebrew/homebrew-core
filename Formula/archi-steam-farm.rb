class ArchiSteamFarm < Formula
  desc "ASF is a C# application that allows you to farm steam cards"
  homepage "https://github.com/JustArchi/ArchiSteamFarm"
  url "https://github.com/JustArchi/ArchiSteamFarm/releases/download/2.3.1.2/ASF.zip"
  version "2.3.1.2"
  sha256 "6d337b57195555fcce0ac30859ee1f67570de00ec7bc30d1785e05dde896e396"

  bottle do
    cellar :any_skip_relocation
    sha256 "ddf1afce7277a662a8ddc7fd554b8e413d35d8dc57535ecbbb2a6ba0c6791401" => :sierra
    sha256 "ddf1afce7277a662a8ddc7fd554b8e413d35d8dc57535ecbbb2a6ba0c6791401" => :el_capitan
    sha256 "ddf1afce7277a662a8ddc7fd554b8e413d35d8dc57535ecbbb2a6ba0c6791401" => :yosemite
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
