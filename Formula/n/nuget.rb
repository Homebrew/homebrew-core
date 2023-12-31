class Nuget < Formula
  desc "Package manager for Microsoft development platform including .NET"
  homepage "https://www.nuget.org/"
  url "https://dist.nuget.org/win-x86-commandline/v6.8.0/nuget.exe" # make sure libexec.install below matches case
  sha256 "6c9e1b09f06971933b08080e7272a2ca5b0d8222500744da757bd8d019013a3d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e9b2794f708ebfb6ec3384dbfbb99c4819fb81d143aab3c92b49cfadd2eca3c4"
  end

  deprecate! date: "2023-10-24", because: "uses deprecated `mono`"

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
