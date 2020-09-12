class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.23/proteinortho-v6.0.23.tar.gz"
  sha256 "e2a93fee6bcbc422e0bbeb98150bf3287c536007397d2bdc4859fc955abb3dc2"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any
    sha256 "49dbf56ff37813fba6bbb4f82d79fd098240c4d4a794656e60acc7697e5d9d70" => :catalina
    sha256 "f6852c5015483ee946d04d9ead6ba577695a33b3cbc5fc9d2028bf7a37b77eb2" => :mojave
    sha256 "1a3d9722dc5396df00c218e3aed145d16fc000f5fe897897eac4b36d2cd1405e" => :high_sierra
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
