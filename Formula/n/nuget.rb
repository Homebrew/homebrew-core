class Nuget < Formula
  desc "Package manager for Microsoft development platform including .NET"
  homepage "https://www.nuget.org/"
  url "https://dist.nuget.org/win-x86-commandline/v6.13.2/nuget.exe"
  sha256 "506085572a662f03bec1a5ffe43f81a240ff99b3765b8dbc0e22c33532775227"
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
    sha256 cellar: :any_skip_relocation, all: "6c10332a8f36227825fd53499baf7a796234e8588ca074ab8110ed8bf69e0736"
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
