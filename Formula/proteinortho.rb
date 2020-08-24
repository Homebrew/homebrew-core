class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.22/proteinortho-v6.0.22.tar.gz"
  sha256 "9a30ae580a360f2898019d9651ab8d6522bfc1abeceb32d17ed1454ba807193d"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any
    sha256 "f912f24a11a4464e8b8cb300e57e72820987f971b23e4ba6686aba451a9bcbd6" => :catalina
    sha256 "a5b209e6072b27bca63f8a45024cdba602ccfd0fa42925dd65eeb53416ca769b" => :mojave
    sha256 "8e8f29a8acfb18f908e8bb060bac9f14e2c771cc4b719831880c48c5ff0a33fe" => :high_sierra
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
