class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat28_5_src.tar.gz"
  version "2.8#5"
  sha256 "3e88f2d2afdda77754e3dde2da50b7a6ee738c98766b03fb9e25cd006ee13652"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "65f46e6838d2c2e8d6e1c2b86467063b80e05df6c617d101e64a4ac7392a112a" => :catalina
    sha256 "925d0dba69e4df3a8c46ec78071f0b7e2fc9bc7e643bf76983f98f7e836cf57e" => :mojave
    sha256 "f2efaa64a26010d39f11e108eca50846926f2920464afa20353331d19533a735" => :high_sierra
  end

  def install
    system "make", "-C", "emu", "-f", "Makefile.mac64"
    bin.install "emu/picat" => "picat"
    prefix.install "lib" => "pi_lib"
    doc.install Dir["doc/*"]
    pkgshare.install "exs"
  end

  test do
    output = shell_output("#{bin}/picat #{pkgshare}/exs/euler/p1.pi").chomp
    assert_equal "Sum of all the multiples of 3 or 5 below 1000 is 233168", output
  end
end
