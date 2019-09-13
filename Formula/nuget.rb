class Nuget < Formula
  desc "Package manager for Microsoft development platform including .NET"
  homepage "https://www.nuget.org/"
  url "https://dist.nuget.org/win-x86-commandline/v5.2.0/nuget.exe"
  sha256 "2865714c6588ef0770b4a04bdd20dac59bcb56756d001c040664c9966f1b835a"

  bottle :unneeded

  depends_on "mono"

  def install
    libexec.install "NuGet.exe" => "nuget.exe"
    (bin/"nuget").write <<~EOS
      #!/bin/bash
      mono #{libexec}/nuget.exe "$@"
    EOS
  end

  test do
    assert_match "NuGet.Protocol.Core.v3", shell_output("#{bin}/nuget list NuGet.Protocol.Core.v3")
  end
end
