class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.3.1/proteinortho-v6.3.1.tar.gz"
  sha256 "9b3f5eb946a4f0f85c362db550163534d7687b8c88906b2eaf81f519de844b08"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5f45f1cda535145f00a565ab2de7d6f33a24c1696b3d5dc53783184c55d95b08"
    sha256 cellar: :any,                 arm64_ventura:  "de9dbe80454f15e46923c62d9fb1f7299d14ee07acb6e435d85a6cabf81b0029"
    sha256 cellar: :any,                 arm64_monterey: "b996a0e721325a96cf4143bed13946442cae1b8e9e796c8cb98e12305fd19470"
    sha256 cellar: :any,                 sonoma:         "e8d6edb4bc0fb0ce91cddd6bf0a075bcb123fdfec8bcb920f720cc568eaf556e"
    sha256 cellar: :any,                 ventura:        "49e920829c10d6aceef190300efd9a02efb812b54b38204bffc20978bbf87a8b"
    sha256 cellar: :any,                 monterey:       "a772cb779fc21a460cbbc2159a1748ad353e70df71adf3c286c16c23b3984c79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48f37a6dd82d511509dae242f4571bba67bd947150a45a171e456a1da8d788b9"
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
