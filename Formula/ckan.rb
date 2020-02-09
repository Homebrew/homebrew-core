class Ckan < Formula
  desc "The Comprehensive Kerbal Archive Network"
  homepage "https://github.com/KSP-CKAN/CKAN/"
  url "https://github.com/KSP-CKAN/CKAN/releases/download/v1.26.8/ckan.exe"
  sha256 "2861fbdff995765b95b93c3ece17fbc7a917a6da8cb89b1563a6a3a64076651f"

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
