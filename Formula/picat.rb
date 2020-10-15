class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org/"
  url "http://picat-lang.org/download/picat28_6_src.tar.gz"
  version "2.8#6"
  sha256 "9366a2b42123645dab4617d849fb456bdaa24a0931e13071c3574bb1332cf29c"

  bottle do
    cellar :any_skip_relocation
    sha256 "f42825e8a240e0dfccbf1bac492a60762acdee285ad51b164965d2b056296212" => :catalina
    sha256 "7b8672d8377c157f4bda1121ba06c5b4dbdc0c7bd4625f4d44440a88999d2168" => :mojave
    sha256 "e9ade38737cb631d139939e92033462caa728e9e9244ec99f4e36182349f6aa5" => :high_sierra
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
