class Nuget < Formula
  desc "Package manager for Microsoft development platform including .NET"
  homepage "https://www.nuget.org/"
  url "https://dist.nuget.org/win-x86-commandline/v4.1.0/nuget.exe"
  version "4.1.0"
  sha256 "4c1de9b026e0c4ab087302ff75240885742c0faa62bd2554f913bbe1f6cb63a0"

  bottle :unneeded

  depends_on "mono" => :recommended

  def install
    libexec.install "NuGet.exe" => "nuget.exe"
    (bin/"nuget").write <<-EOS.undent
      #!/bin/bash
      mono #{libexec}/nuget.exe "$@"
    EOS
  end

  test do
    output = shell_output("#{bin}/nuget list NuGet.Protocol.Core.v3")
    assert_match "NuGet.Protocol.Core.v3", output
  end
end
