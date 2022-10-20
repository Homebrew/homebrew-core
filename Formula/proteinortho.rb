class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.1.1/proteinortho-v6.1.1.tar.gz"
  sha256 "04fad661070d33d42df542ecf04db07e496b1efcc29bdd5fd7cdefafaa2dd0b1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "522facb215d0a9ab32c7f3d9961aee3fb4843cf886dd4c9e8a1d7467e2524bd4"
    sha256 cellar: :any,                 arm64_big_sur:  "5f82ef64fdf89f431c9a6bbb72c6571a89559063c240daca8ad56b4866cd4255"
    sha256 cellar: :any,                 monterey:       "6526762a63f49b55792ca9f8db682b8d493baa3a210616807e5a17ceb130bbf7"
    sha256 cellar: :any,                 big_sur:        "3bbd53268a3765bef5366c82c429711327cdc11467cf26771bcb19db00ae07b0"
    sha256 cellar: :any,                 catalina:       "61cc8920352ef691e2c364a48ddcc63039004390c4f30aff1fbd350f11a73e0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74aa1edeb64b267f915a09a5d5657bcb925be7cf67153c8e90513b3a7fd03adf"
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
