class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.8/proteinortho-v6.0.8.tar.gz"
  sha256 "41ab67e7a2c26976c295c474faecb93607f191e2da6ee059e353da7c50217dec"

  bottle do
    cellar :any
    sha256 "ce76c1046bfa3115bbb9564c58cd7936351102c0214b1d7334977b9ca30262df" => :catalina
    sha256 "173453f36993f30911c18cc5ad951908c0c22af982ba12a4eae46791cd43754a" => :mojave
    sha256 "da1a582aa0b8019b86999f35dd2792705ff5668768f1937085a0676874eee0ce" => :high_sierra
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
