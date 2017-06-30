class Nuget < Formula
  desc "Package manager for Microsoft development platform including .NET"
  homepage "https://www.nuget.org/"
  url "https://dist.nuget.org/win-x86-commandline/v4.0.0/NuGet.exe"
  sha256 "cc52f94b2f1ba7cd485e546f8059cada2e9daee2ae27abde54507e9b1661e6d1"

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
