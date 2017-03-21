class ArchiSteamFarm < Formula
  desc "ASF is a C# application that allows you to farm steam cards"
  homepage "https://github.com/JustArchi/ArchiSteamFarm"
  url "https://github.com/JustArchi/ArchiSteamFarm/releases/download/2.2.3.7/ASF.zip"
  version "2.2.3.7"
  sha256 "69b113821dd618373b8c34a1832fa01d7399be44c3580a4723647586b27d245c"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1c970bca2939b5ffc5bc8ee25a1ff7375652e6274ec30a11bb9c54f0b9923d2" => :sierra
    sha256 "c1c970bca2939b5ffc5bc8ee25a1ff7375652e6274ec30a11bb9c54f0b9923d2" => :el_capitan
    sha256 "c1c970bca2939b5ffc5bc8ee25a1ff7375652e6274ec30a11bb9c54f0b9923d2" => :yosemite
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
