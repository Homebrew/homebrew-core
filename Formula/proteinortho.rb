class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.2/proteinortho-v6.0.2.tar.gz"
  sha256 "36127c87cdef99bd4b9a80d06cb220d734f131a4d3434ab5ba7933b2613b5123"

  bottle do
    cellar :any
    sha256 "bfa3585f2cd437c42f290273f269b2e1c82329bd05b790a724f0aac47c4821ae" => :mojave
    sha256 "4b5c8f9e5a964660c766c099bc6a06b5df4b5216aac6edd802a2ed88f88c8995" => :high_sierra
    sha256 "2ebed9e09ca6d3c238c10d272cd496f140ef1b11a3e0d08261d6c65d85defc25" => :sierra
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
