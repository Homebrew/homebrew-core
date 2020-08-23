class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.21/proteinortho-v6.0.21.tar.gz"
  sha256 "fa7177da0f3fe42eb59f6287c52e05568b4f4cb9c4e2b1640ac87af6c9080420"
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
