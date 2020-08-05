class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.20/proteinortho-v6.0.20.tar.gz"
  sha256 "443753505e19ada691891d4da18a26ca1f6f5d34a14ca0b69aa25cd176273b82"
  license "GPL-3.0"

  bottle do
    cellar :any
    sha256 "31b037291952a48f55b7529e150db714507023a485a639da644c817946116c20" => :catalina
    sha256 "3fdaffaeb7800c10549fc171bcc49bbc3914b1bf26548c5e571ee834609444a2" => :mojave
    sha256 "e19a93b85f6f3b5cd2a793b5bc18b1624bbc4b8591b2e266d667459d7a951fbb" => :high_sierra
  end

  depends_on "diamond"
  depends_on "openblas"

  def install
    bin.mkpath
    system "make", "install", "PREFIX=#{bin}"
    doc.install "manual.html"
  end

  test do
    system "#{bin}/proteinortho", "-test"
    system "#{bin}/proteinortho_clustering", "-test"
  end
end
