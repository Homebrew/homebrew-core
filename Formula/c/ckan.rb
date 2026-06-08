class Ckan < Formula
  desc "Comprehensive Kerbal Archive Network"
  homepage "https://github.com/KSP-CKAN/CKAN/"
  url "https://github.com/KSP-CKAN/CKAN/releases/download/v1.36.4/ckan.exe"
  sha256 "7748082cdfcf2dbb5f502261b18afc85003193894c60427d04b0ac7a8dfef7de"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c0cf6076bb24c81f0b6c26fa2f14e1c0ef2b341190185e9c69a10cafd1ae813f"
  end

  depends_on "mono"

  def install
    (libexec/"bin").install "ckan.exe"
    (bin/"ckan").write <<~SHELL
      #!/bin/sh
      exec mono "#{libexec}/bin/ckan.exe" "$@"
    SHELL
  end

  def caveats
    <<~EOS
      To use the CKAN GUI, install the ckan-app cask.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ckan version")

    output = shell_output("#{bin}/ckan update", 1)
    assert_match "I don't know where a game instance is installed", output
  end
end
