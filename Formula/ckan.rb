class Ckan < Formula
  desc "The Comprehensive Kerbal Archive Network"
  homepage "https://github.com/KSP-CKAN/CKAN/"
  url "https://github.com/KSP-CKAN/CKAN/releases/download/v1.25.2/ckan.exe"
  sha256 "586f13072cac269014d026d5e9e40b2d62436f69051c81ef53e991f9de3a5203"

  bottle :unneeded

  depends_on "mono"

  def install
    (libexec/"bin").install "ckan.exe"
    (bin/"ckan").write <<~EOS
      #!/bin/sh
      exec mono "#{libexec}/bin/ckan.exe" "$@"
    EOS
  end

  def caveats; <<~EOS
    To use the CKAN GUI, install the ckan-app cask.
  EOS
  end

  test do
    system bin/"ckan", "version"
  end
end
