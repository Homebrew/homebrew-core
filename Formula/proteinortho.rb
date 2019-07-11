class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.6/proteinortho-v6.0.6.tar.gz"
  sha256 "5b58f8fdfa49b9f6d1823d75784c12d246a6b5d8f2b5fce52fde7ab4b9229a55"

  bottle do
    cellar :any
    sha256 "03e6dfc5a4ed2ef87e363a5000e6a57a3bf0d64c74d3fed4f4bcaf94a18dbba7" => :mojave
    sha256 "26801b43025d747e26bcd1c498c0e3a05a94a25d13dc8d32a100aaca5e5008ab" => :high_sierra
    sha256 "cb369664b3dcdb4f57e28c90e2a9cf268023b1def15908e9f45e2bbc3bc6ef56" => :sierra
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
