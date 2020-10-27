class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.24/proteinortho-v6.0.24.tar.gz"
  sha256 "8c37ae3e99488b95a5e9f78df34bf0f049e127fc9abcbb76a2aab0e856d89acb"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any
    sha256 "64bdb7f9f849d72288be90574052f42e7939a4e9feb0df2225398357e7fcceba" => :catalina
    sha256 "ae06bdd7d035985c4894996acc4f2b61be32df12694897e3b610c12493ece8ba" => :mojave
    sha256 "4dc90465f2c778fc033af1bce1c5de64a6c924d407d3ee91089709d4946f289b" => :high_sierra
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
