class Nsnake < Formula
  desc "Classic snake game with textual interface"
  homepage "https://github.com/alexdantas/nSnake"
  url "https://downloads.sourceforge.net/project/nsnake/GNU-Linux/nsnake-3.0.1.tar.gz"
  sha256 "e0a39e0e188a6a8502cb9fc05de3fa83dd4d61072c5b93a182136d1bccd39bb9"
  head "https://github.com/alexdantas/nSnake.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6ff26e57639f58e6bc2bbd36c511d3c21cf0b5e818b270efb6ae14e542c780c0" => :catalina
    sha256 "195e486eb84a9fa230bfa31558d6b3fb8ae6715ab444f3aead9c997a43f981d8" => :mojave
    sha256 "5f8de3bf4148a6d9fdb32b5584e4aa5890c8f373ad5be36b17473e4d7c2f0a96" => :high_sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"

    # No need for Linux desktop
    (share/"applications").rmtree
    (share/"icons").rmtree
    (share/"pixmaps").rmtree
  end

  test do
    assert_match /nsnake v#{version} /, shell_output("#{bin}/nsnake -v")
  end
end
