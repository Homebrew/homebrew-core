class Nuget < Formula
  desc "Package manager for Microsoft development platform including .NET"
  homepage "https://www.nuget.org/"
  url "https://dist.nuget.org/win-x86-commandline/v3.4.3/nuget.exe"
  version "3.4.3"
  sha256 "3b1ea72943968d7af6bacdb4f2f3a048a25afd14564ef1d8b1c041fdb09ebb0a"

  bottle :unneeded

  depends_on "mono"

  def install
    libexec.install "nuget.exe"
    (bin/"nuget").write <<-EOS.undent
      #!/bin/bash
      mono #{libexec}/nuget.exe "$@"
    EOS
  end

  test do
    assert_match "NuGet.Protocol.Core.v3", shell_output("#{bin}/nuget list NuGet.Protocol.Core.v3")
  end
end
