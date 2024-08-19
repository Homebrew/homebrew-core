class Ckan < Formula
  desc "Comprehensive Kerbal Archive Network"
  homepage "https://github.com/KSP-CKAN/CKAN/"
  url "https://github.com/KSP-CKAN/CKAN/releases/download/v1.34.4/ckan.exe"
  sha256 "4f7481cc6993c0566c1247779022bb6ae20d28fb05c76cc8611dbf66ab790133"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "688c8e4800a892647c8c27e53c14e0f844723609c34934427f82db1c18b383fd"
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
