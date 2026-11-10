class Nuget < Formula
  desc "Package manager for Microsoft development platform including .NET"
  homepage "https://www.nuget.org/"
  url "https://dist.nuget.org/win-x86-commandline/v8.0.0/nuget.exe"
  sha256 "d4ddb222cb8fca8200b59e82286c0cba9c29b4fce6f9835fdfa54e67c9483d07"
  license "MIT"

  livecheck do
    url "https://dist.nuget.org/tools.json"
    strategy :json do |json|
      json["nuget.exe"]&.map do |item|
        next if item["stage"] != "ReleasedAndBlessed"

        item["version"]
      end
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6227f9f3c8b1860e1be3aac7986cb5cb50892dd452ac6d5f779fdcec50cb2e60"
  end

  depends_on "mono"

  def install
    libexec.install "nuget.exe"
    (bin/"nuget").write <<~BASH
      #!/bin/bash
      mono #{libexec}/nuget.exe "$@"
    BASH
  end

  test do
    assert_match "NuGet.Protocol.Core.v3", shell_output("#{bin}/nuget list packageid:NuGet.Protocol.Core.v3")
  end
end
