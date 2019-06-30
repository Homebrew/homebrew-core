class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.4/proteinortho-v6.0.4.tar.gz"
  sha256 "b4cb17310ba98bec085eefe49834792b684e83cf992ea95114a6485663b4e3ab"

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
