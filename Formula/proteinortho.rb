class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.33/proteinortho-v6.0.33.tar.gz"
  sha256 "332f61eee4ea6f3e27b38e123bb78b5263627fb5a4fd3609502877d8c0af7373"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "065b50aa670fd6a774cbe05d70b04afe49aef1c16546177591b04cde49ca5cdf"
    sha256 cellar: :any,                 arm64_big_sur:  "cbd52835af110e3abf82a0b6d443e1d7c882aeea4416ddb284a2d93140958baf"
    sha256 cellar: :any,                 monterey:       "0c1614bdcd418382b49f17b633dbc945da1771d0a04e3e873770eff920f22822"
    sha256 cellar: :any,                 big_sur:        "151a5107cc73bc4065feaa1fa56d92243db829ef06c4b2d4fbfceea0a3f002da"
    sha256 cellar: :any,                 catalina:       "26c98fe2d6e10ee47e78e636fccc19084c639e053ea60dcaecde9c0b6324edf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "338faa4447411d784eb0b7752b5ff59e94be6e9509d36a29a6cb8361563e8c87"
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
