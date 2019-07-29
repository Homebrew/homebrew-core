class Ckan < Formula
  desc "The Comprehensive Kerbal Archive Network"
  homepage "https://github.com/KSP-CKAN/CKAN/"
  url "https://github.com/KSP-CKAN/CKAN/releases/download/v1.26.2/ckan.exe"
  sha256 "a0b4c43640d91ef5a0c3171906152636de75bf8497a1dc85d116a97c2c416185"

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
