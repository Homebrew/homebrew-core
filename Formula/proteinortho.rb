class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.28/proteinortho-v6.0.28.tar.gz"
  sha256 "e4489734646e389fbb7bffc6f6e511507093e7ea023253dc9f24d95cd0f014a2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2bd0dd7a2a8440bf7a96490adcdfc1c1362bb40ea6f396b864c801907b90ef20"
    sha256 cellar: :any, big_sur:       "7529868482e212a328b2ab9e78cddbf545688beaa617189177d6f4a9c9b2ea1d"
    sha256 cellar: :any, catalina:      "3cb6af47edf26a2f4a093bc8ef436f57737515bd2595efc1a45eef43107e5432"
    sha256 cellar: :any, mojave:        "71ba13bb5916cf7c4a52e13969a92e8a77f5e8602e86625620ba1f05e5e87593"
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
