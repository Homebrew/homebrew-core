class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.2.3/proteinortho-v6.2.3.tar.gz"
  sha256 "8bdf788b612064d02f30db9c7c9fed6f35040710bf611d01c467f05f4d6befe3"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cbed8d86857c8fbc52e4319cd8f30572bde2674d10107245fcabc0758b317d9d"
    sha256 cellar: :any,                 arm64_monterey: "0320b52d8c3e9e71f3691965e1ff92a480bdd1ae8a8439d0c12e7dd847377500"
    sha256 cellar: :any,                 arm64_big_sur:  "e5874b6b6c5c19de58d2ef2d385752a20f08942f1257c2eb2ff148d9be23cc9e"
    sha256 cellar: :any,                 ventura:        "64c8091c46565bd2177bb901572bc0b92959b060b4ee86b5b702a0916a63cdb4"
    sha256 cellar: :any,                 monterey:       "1eb863495f6654f111c5b33b9c0988948bfa1e660f409b3515879b1bf4713a2e"
    sha256 cellar: :any,                 big_sur:        "a8904e833373e5f725978f6be32d5aa1d554d4cbe3dc86c30280fb717982031c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a822ed637b7a9524b28e6814631761678fc5a535dbef954fc3ce5eee9376caa"
  end

  depends_on "diamond"
  depends_on "openblas"

  def install
    ENV.cxx11

    bin.mkpath
    system "make", "install", "PREFIX=#{bin}"
    doc.install "manual.html"
  end

  test do
    system "#{bin}/proteinortho", "-test"
    system "#{bin}/proteinortho_clustering", "-test"
  end
end
