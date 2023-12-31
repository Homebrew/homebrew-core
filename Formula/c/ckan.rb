class Ckan < Formula
  desc "Comprehensive Kerbal Archive Network"
  homepage "https://github.com/KSP-CKAN/CKAN/"
  url "https://github.com/KSP-CKAN/CKAN/releases/download/v1.34.2/ckan.exe"
  sha256 "31468a82d2c756cad4cb9e651de9656b66026e52c67678f4e77d2a0b995ad881"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "129e7ef8d2e4c8e73b461f701291b3271b345f424cc2b447ce73735735a13558"
  end

  deprecate! date: "2023-10-24", because: "uses deprecated `mono`"

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
