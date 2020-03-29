class Ckan < Formula
  desc "The Comprehensive Kerbal Archive Network"
  homepage "https://github.com/KSP-CKAN/CKAN/"
  url "https://github.com/KSP-CKAN/CKAN/releases/download/v1.27.0/ckan.exe"
  sha256 "f608acdfc3b957aad21d959b83e657e4e1ef0ba2de01a51fbd22d53244cd5ea0"

  bottle :unneeded

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
    system bin/"ckan", "version"
  end
end
