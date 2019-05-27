class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.2/proteinortho-v6.0.2.tar.gz"
  sha256 "36127c87cdef99bd4b9a80d06cb220d734f131a4d3434ab5ba7933b2613b5123"

  bottle do
    cellar :any
    sha256 "7e9ee7c46efd1ba8fed06d37d7035178a135471a79c7cf7864d4fadb2e9752d6" => :mojave
    sha256 "b297fca02b8117e5c3dd7f8fedc53f434a19b4052064bec8e788e7976330f527" => :high_sierra
    sha256 "b681f87a67b9d27077f3c9a915c4cce5104525ad015f51b7975fedb1d11c254c" => :sierra
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
