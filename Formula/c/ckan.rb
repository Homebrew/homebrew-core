class Ckan < Formula
  desc "Comprehensive Kerbal Archive Network"
  homepage "https://github.com/KSP-CKAN/CKAN/"
  url "https://github.com/KSP-CKAN/CKAN/releases/download/v1.36.2/ckan.exe"
  sha256 "11949ffa7e90504656d818e5d9a73fe9ef89a3e3e5c567756753ca1ef802fcaa"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c0d0e423272db4767bdbd53bcef9a7140114f5501b9328a0bebe75ad06b27c04"
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
