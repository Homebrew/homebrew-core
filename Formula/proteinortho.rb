class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.4/proteinortho-v6.0.4.tar.gz"
  sha256 "b4cb17310ba98bec085eefe49834792b684e83cf992ea95114a6485663b4e3ab"

  bottle do
    cellar :any
    sha256 "769bda467ad8e5675679f336a289e93292f5210412a1fc7d7f57d500d40abedb" => :mojave
    sha256 "3ab86f03640e985861469f20fbfc86f060295a7ae44e59197446e4c7e7ef3441" => :high_sierra
    sha256 "4260e433d13c458fcef3a58a924753396a5171c3cb67ea0646f8b5ba55a9bf6e" => :sierra
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
