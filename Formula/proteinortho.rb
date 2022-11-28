class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.1.5/proteinortho-v6.1.5.tar.gz"
  sha256 "cf3b368ff73a7290f318081d37d9125eeb61a59507608814b8ae9be5736969cc"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e67b6d24d64ae92bfea8a631c61b1c67bae1ecf3146232587bd5ce5e4d132234"
    sha256 cellar: :any,                 arm64_monterey: "b5cee7502a5712a476816a75233713e5684888e87218a6fd613adbf7958169d3"
    sha256 cellar: :any,                 arm64_big_sur:  "dd686d6703bb091b68d64334a1fdbf346c772d1b731d41d1b5d830c509aaaf3d"
    sha256 cellar: :any,                 monterey:       "5eac5d289548c772d6a0011f9d1fff133de99a275dfbe473c43590a7063eeb70"
    sha256 cellar: :any,                 big_sur:        "8b85ebd666ea68debf5f6b49064d7b8c76e4c87fa07c8f4f4e19183514e5f4e1"
    sha256 cellar: :any,                 catalina:       "e88ed9c8811674e6825291d0596677d5e84e9f3abed58fc87ddc2ed472053346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f9252f798a8571234659f33bc8838bd5ffd4494503ee7fbbbdfa72d7b5aa487"
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
