class Ckan < Formula
  desc "The Comprehensive Kerbal Archive Network"
  homepage "https://github.com/KSP-CKAN/CKAN/"
  url "https://github.com/KSP-CKAN/CKAN/releases/download/v1.25.3/ckan.exe"
  sha256 "7c33293809f5d04028053ae405fb7b328d161e2855eeb95fe2f6e66570727575"

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
