class Nuget < Formula
  desc "Package manager for Microsoft development platform including .NET"
  homepage "https://www.nuget.org/"
  url "https://dist.nuget.org/win-x86-commandline/v5.10.0/nuget.exe" # make sure libexec.install below matches case
  sha256 "852b71cc8c8c2d40d09ea49d321ff56fd2397b9d6ea9f96e532530307bbbafd3"
  license "MIT"

  livecheck do
    url "https://dist.nuget.org/tools.json"
    regex(%r{"url":\s*?"[^"]+/v?(\d+(?:\.\d+)+)/nuget\.exe",\s*?"stage":\s*?"ReleasedAndBlessed"}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "58c9fcc4b63f59fa0d3d2c6e12e94f846dead10100b6e4f4c2c75d3384296725"
  end

  depends_on arch: :x86_64
  depends_on "mono"

  def install
    libexec.install "nuget.exe" => "nuget.exe"
    (bin/"nuget").write <<~EOS
      #!/bin/bash
      mono #{libexec}/nuget.exe "$@"
    EOS
  end

  test do
    assert_match "NuGet.Protocol.Core.v3", shell_output("#{bin}/nuget list packageid:NuGet.Protocol.Core.v3")
  end
end
