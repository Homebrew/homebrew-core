class Ckan < Formula
  desc "The Comprehensive Kerbal Archive Network"
  homepage "https://github.com/KSP-CKAN/CKAN/"
  url "https://github.com/KSP-CKAN/CKAN/releases/download/v1.25.1/ckan.exe"
  sha256 "39a5a001fc86728b3b33b6c1c220c5d1fba094ee12343d1d3d7055f455823489"

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
