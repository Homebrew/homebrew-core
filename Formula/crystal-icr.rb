class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/greyblake/crystal-icr"
  url "https://github.com/greyblake/crystal-icr/archive/v0.2.13.tar.gz"
  sha256 "33763fa190baad390df7143b437b1ddda3867a12ccf6e11c3278e53ecb94e40a"
  revision 1

  bottle do
    sha256 "88527c9ac0ee79319de10f816b19328ebf5c005a5690072fed1ac13d38c271ec" => :sierra
    sha256 "4adf753310f1144c1105389ac7d752edf236337a52ac419c81490e2af2f8655e" => :el_capitan
    sha256 "88e5bd242523c81ce04d26ac8bc4a16f2cb5f9a70b49fe9b085b2d04b521f4b9" => :yosemite
  end

  depends_on "crystal-lang"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "icr version #{version}", shell_output("#{bin}/icr -v")
  end
end
