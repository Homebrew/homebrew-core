class Nuget < Formula
  desc "Package manager for Microsoft development platform including .NET"
  homepage "https://www.nuget.org/"
  url "https://dist.nuget.org/win-x86-commandline/v4.4.1/NuGet.exe"
  sha256 "781930966cf218ca01560c11f99f3c7423aa734c3bbe480179b85a7eba69d9b2"

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
