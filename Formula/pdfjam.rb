class Pdfjam < Formula
  desc "Simple shell interface to the pdfpages package for pdfLaTeX"
  homepage "https://go.warwick.ac.uk/pdfjam"
  url "https://go.warwick.ac.uk/pdfjam/pdfjam_208.tgz"
  version "2.08"
  sha256 "c731c598cfad076c985526ff89cbf34423a216101aa5e2d753a71de119ecc0f3"

  bottle :unneeded

  def install
    bin.install Dir["bin/pdf*"]
    man1.install Dir["man1/pdf*.1"]
    etc.install "pdfjam.conf"
  end

  def caveats; <<~EOS
    pdfjam requires the installation of pdfLaTeX. You may need to install the
    Tex Live in your macOS. Both MacTex (brew cask install mactex) and
    BasicTex (brew cask install basictex) works well.
    EOS
  end

  test do
    system "#{bin}/pdfjam", "--version"
  end
end
