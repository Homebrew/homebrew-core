class Nuget < Formula
  desc "Package manager for Microsoft development platform including .NET"
  homepage "https://www.nuget.org/"
  url "https://dist.nuget.org/win-x86-commandline/v6.14.0/nuget.exe"
  sha256 "92dbed160ddee0f64b901e907439e021211b428e57c089ecc12fc38dcc4bd9a5"
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
    sha256 cellar: :any_skip_relocation, all: "e7a94ca9119b9bb55b584ca97d66e390a0a5271ea53689820f954c7b17fc548b"
  end

  depends_on "mono"

  def install
    libexec.install "nuget.exe" => "nuget.exe"
    (bin/"nuget").write <<~BASH
      #!/bin/bash
      mono #{libexec}/nuget.exe "$@"
    BASH
  end

  test do
    assert_match "NuGet.Protocol.Core.v3", shell_output("#{bin}/nuget list packageid:NuGet.Protocol.Core.v3")
  end
end
