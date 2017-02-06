class Nsnake < Formula
  desc "Classic snake game with textual interface"
  homepage "http://nsnake.alexdantas.net/"
  url "https://downloads.sourceforge.net/project/nsnake/GNU-Linux/nsnake-3.0.1.tar.gz"
  sha256 "e0a39e0e188a6a8502cb9fc05de3fa83dd4d61072c5b93a182136d1bccd39bb9"
  head "https://github.com/alexdantas/nSnake.git"

  bottle do
    sha256 "46aa5c2e7ad88a8aac26ecc50c649ab10bea44f2dcfc93baf0318330efa4de6f" => :el_capitan
    sha256 "a862406eef08f74430c46fa68894c39ac34448d24ea62f247a49851b867a0679" => :yosemite
    sha256 "c38fb4274610227b8dc9351c53887bb57f7539e6eec45172502f7c6ffac2d6f9" => :mavericks
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
