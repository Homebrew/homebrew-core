class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.6/proteinortho-v6.0.6.tar.gz"
  sha256 "5b58f8fdfa49b9f6d1823d75784c12d246a6b5d8f2b5fce52fde7ab4b9229a55"

  bottle do
    cellar :any
    sha256 "8a2d2f96d932786e1357cf3b5d7ba11e5806752add4fd57c6cba726bdd533103" => :mojave
    sha256 "efc3cb8e26512f7bbdf88e5543984e48ebd657410273fa0d56741efc0d63d321" => :high_sierra
    sha256 "9ac40021739a8d0ba1214306673d828efb33c23f60399084d41846972fff0a7f" => :sierra
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
