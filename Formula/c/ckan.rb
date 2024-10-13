class Ckan < Formula
  desc "Comprehensive Kerbal Archive Network"
  homepage "https://github.com/KSP-CKAN/CKAN/"
  url "https://github.com/KSP-CKAN/CKAN/releases/download/v1.35.2/ckan.exe"
  sha256 "48ad9e29d1ff6e6f96faa53c5d41d10fdb9f7e67e9e5b478741bc11142829bc1"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cfe6a4662dbd9f9ce458b9e9c57ffcee586850264619d2a5ea85978ef5b32039"
  end

  depends_on "mono"

  def install
    (libexec/"bin").install "ckan.exe"
    (bin/"ckan").write <<~EOS
      #!/bin/sh
      exec mono "#{libexec}/bin/ckan.exe" "$@"
    EOS
  end

  def caveats
    <<~EOS
      To use the CKAN GUI, install the ckan-app cask.
    EOS
  end

  test do
    assert_match version.to_s, shell_output(bin/"ckan version")

    output = shell_output(bin/"ckan update", 1)
    assert_match "I don't know where a game instance is installed", output
  end
end
