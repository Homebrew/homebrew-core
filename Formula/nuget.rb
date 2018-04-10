class Nuget < Formula
  desc "Package manager for Microsoft development platform including .NET"
  homepage "https://www.nuget.org/"
  url "https://dist.nuget.org/win-x86-commandline/v4.6.2/NuGet.exe"
  sha256 "2c562c1a18d720d4885546083ec8eaad6773a6b80befb02564088cc1e55b304e"

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
