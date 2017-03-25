class ArchiSteamFarm < Formula
  desc "ASF is a C# application that allows you to farm steam cards"
  homepage "https://github.com/JustArchi/ArchiSteamFarm"
  url "https://github.com/JustArchi/ArchiSteamFarm/releases/download/2.3.0.5/ASF.zip"
  version "2.3.0.5"
  sha256 "bcdfdfdb2b6c31e2f2ce21b6565b09831fb1406e19f5bd2553f9a0baa17558e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "cac26b71eeaacf67336cc9e5c709c37df3cb43eef05e862c4898e5abd9eb6821" => :sierra
    sha256 "cac26b71eeaacf67336cc9e5c709c37df3cb43eef05e862c4898e5abd9eb6821" => :el_capitan
    sha256 "cac26b71eeaacf67336cc9e5c709c37df3cb43eef05e862c4898e5abd9eb6821" => :yosemite
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
