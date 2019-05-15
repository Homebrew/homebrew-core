class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.1/proteinortho-v6.0.1.tar.gz"
  sha256 "fbb4ebaf008ed7454d0fde20a5c067b25dc715e44e3c833f7e5a3451fe8e31e0"

  bottle do
    cellar :any
    sha256 "63d822bb350f68d92545699b38bb52ad664d26d9af1d03ea4166c7eba04a5863" => :mojave
    sha256 "a30242255d6921a204885655e9c825db5cbac8b1b81001efc4dd87614c1e73dc" => :high_sierra
    sha256 "e8d46227d0e30f8c83a59d0445e93a7d81fd852cbab3b9760f638c9c2b25b715" => :sierra
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
