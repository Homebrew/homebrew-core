class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.10/proteinortho-v6.0.10.tar.gz"
  sha256 "8fa5f5cc1dd0397a76230bf4f5269df7bbded891d9a1d2e2819d5ff2d1ed86fd"

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
