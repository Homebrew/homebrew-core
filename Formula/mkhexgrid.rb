class Mkhexgrid < Formula
  desc "Fully-configurable hex grid generator"
  homepage "http://www.nomic.net/~uckelman/mkhexgrid/"
  url "http://www.nomic.net/~uckelman/mkhexgrid/releases/mkhexgrid-0.1.1.src.tar.bz2"
  sha256 "122609261cc91c2063ab5315d4316a27c9a0ab164f663a6cb781dd87310be3dc"

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
