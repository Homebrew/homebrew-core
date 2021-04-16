class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.30/proteinortho-v6.0.30.tar.gz"
  sha256 "0452bdbc614261520f4bce0c08eedc99d004a15d2ec78a884d2e112fe7e23b01"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e708a2b5fb988519555a12d3b19f8bda467f80d75d5ce7c4689f79731f8fbb50"
    sha256 cellar: :any, big_sur:       "ad81597e67d53cc98ee58d403d5b14ced7f1b15f0fadd753c9c8d5dcadf0fd03"
    sha256 cellar: :any, catalina:      "d08b2626e480eed75452c12eb70081f3097befb2f97bfa9ed2cf070c03db5ffd"
    sha256 cellar: :any, mojave:        "cf6facc85e0125bdb1b4ccf7d6051f89391b26e6fec8551cc9ac41a98b6a8c3c"
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
