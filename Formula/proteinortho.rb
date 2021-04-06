class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.30/proteinortho-v6.0.30.tar.gz"
  sha256 "0452bdbc614261520f4bce0c08eedc99d004a15d2ec78a884d2e112fe7e23b01"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0565d76a8b123904daa892b6de015809d3d5acc3d72497319d7111b1a8364bb1"
    sha256 cellar: :any, big_sur:       "6eeb1b710a5e0925111cb485374b47cce10eebe55ead39b06a2881e7d5c7030f"
    sha256 cellar: :any, catalina:      "eedaa51231524a31acd045922f2f7174ff8fb588d69dbc101f65b902cb2c1f5b"
    sha256 cellar: :any, mojave:        "e8080c1718573fe68ec9e3a64cac948ee8865f61a2ceae449647e6f5a83b9dca"
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
