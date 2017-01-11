class Nuget < Formula
  desc "Package manager for Microsoft development platform including .NET"
  homepage "https://www.nuget.org/"
  url "https://dist.nuget.org/win-x86-commandline/v3.4.4/NuGet.exe"
  version "3.4.4"
  sha256 "c12d583dd1b5447ac905a334262e02718f641fca3877d0b6117fe44674072a27"

  bottle :unneeded

  depends_on "mono"

  def install
    libexec.install "NuGet.exe" => "nuget.exe"
    (bin/"nuget").write <<-EOS.undent
      #!/bin/bash
      mono #{libexec}/nuget.exe "$@"
    EOS
  end

  test do
    assert_match "NuGet.Protocol.Core.v3", shell_output("#{bin}/nuget list NuGet.Protocol.Core.v3")
  end
end
