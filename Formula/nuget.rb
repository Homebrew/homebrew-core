class Nuget < Formula
  desc "Package manager for Microsoft development platform including .NET"
  homepage "https://www.nuget.org/"
  url "https://dist.nuget.org/win-x86-commandline/v6.1.0/nuget.exe" # make sure libexec.install below matches case
  sha256 "432d322b16ffab3fed5d24ab7ea30ae10c555a00339a9bf53060aa4b2aee7925"
  license "MIT"

  livecheck do
    url "https://dist.nuget.org/tools.json"
    regex(%r{"url":\s*?"[^"]+/v?(\d+(?:\.\d+)+)/nuget\.exe",\s*?"stage":\s*?"ReleasedAndBlessed"}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8e0769492789044f1eefbda18a3709aae5b97066d6a9497b787263693a1a438a"
  end

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
