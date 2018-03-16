class Ckan < Formula
  desc "The Comprehensive Kerbal Archive Network"
  homepage "https://github.com/KSP-CKAN/CKAN/"
  url "https://github.com/KSP-CKAN/CKAN/releases/download/v1.24.0/ckan.exe", :using => :nounzip
  sha256 "b25ba43c45bf6e23bd9687620e0026fc81dbb830a92fae1dde54a7871167f979"

  bottle :unneeded

  depends_on "mono"

  def caveats; <<~EOS
    To use the CKAN GUI, install the ckan-app cask.
    EOS
  end

  def install
    (libexec/"bin").install "ckan.exe"
    (bin/"ckan").write <<~EOS
      #!/bin/sh
      exec mono "#{libexec}/bin/ckan.exe" "$@"
    EOS
  end

  test do
    system bin/"ckan", "version"
  end
end
