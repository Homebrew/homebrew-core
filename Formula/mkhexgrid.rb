class Mkhexgrid < Formula
  desc "Fully-configurable hex grid generator"
  homepage "http://www.nomic.net/~uckelman/mkhexgrid/"
  url "http://www.nomic.net/~uckelman/mkhexgrid/releases/mkhexgrid-0.1.1.src.tar.bz2"
  sha256 "122609261cc91c2063ab5315d4316a27c9a0ab164f663a6cb781dd87310be3dc"

  bottle do
    cellar :any
    sha256 "dc24513041f3dc8ae8cd27abb07aeb028074a636b3a139dfa6e862eee73237f5" => :mojave
    sha256 "66011c65d0a32036f58b67ae41ca6a61eb307bc92d958dec026f88e180cab972" => :high_sierra
    sha256 "d2be4b1376fbeb90429433d0cae9b95b8b927701038156a7cb3d73a49620548f" => :sierra
    sha256 "a87808f88a90308adfb14cf89b3bd89251580301f40ba18d08816de2df0be632" => :el_capitan
    sha256 "ec463b01aecec2cc76cd6f91761867fa0efbdeddf60f09bc134f45822006889b" => :yosemite
  end

  depends_on "boost"
  depends_on "gd"

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! "DESTDIR", prefix
      s.change_make_var! "CC", ENV.cc
      # don't chown/chgrp the installed files
      s.gsub! "-o 0 -g 0", ""
    end
    inreplace "mkhexgrid.cpp" do |s|
      s.sub! "catch (exception &e)", "catch (std::exception &e)"
    end
    system "make" # needs to be separate
    system "make", "install"
  end

  test do
    # test the example from the man page (but without inches)
    system "#{bin}/mkhexgrid", "--output=ps", "--image-width=2448",
      "--image-height=1584", "--hex-side=36", "--coord-bearing=0",
      "--coord-dist=22", "--coord-size=8", "--grid-thickness=1",
      "--coord-font=Helvetica", "--grid-grain=h", "--grid-start=o",
      "--coord-tilt=-90", "--centered", "-o", "test.ps"
  end
end
