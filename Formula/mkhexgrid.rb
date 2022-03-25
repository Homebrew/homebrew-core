class Mkhexgrid < Formula
  desc "Fully-configurable hex grid generator"
  homepage "https://www.nomic.net/~uckelman/mkhexgrid/"
  url "https://www.nomic.net/~uckelman/mkhexgrid/releases/mkhexgrid-0.1.1.src.tar.bz2"
  sha256 "122609261cc91c2063ab5315d4316a27c9a0ab164f663a6cb781dd87310be3dc"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?mkhexgrid[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "5b461772bb6b74ee5cc07db25a8baf6055941f93cba08946bb7174e024298e7d"
    sha256 cellar: :any, arm64_big_sur:  "488eb3b7fa3023c4326755bd7bd3546b926d3e03e353063d700c3f15c41e59f1"
    sha256 cellar: :any, monterey:       "54d4b953eefd88048279f0742a636d343aa81cc1b077f4cffd40c57e1b49ceb9"
    sha256 cellar: :any, big_sur:        "ea516f25e28f2f0dae0223de16f1d27abd08f658ee85fb8caab7c41f02f3932b"
    sha256 cellar: :any, catalina:       "0e358685212d241af28055f0a47392bf077575469426e5bc4e38352847451325"
    sha256 cellar: :any, mojave:         "dc24513041f3dc8ae8cd27abb07aeb028074a636b3a139dfa6e862eee73237f5"
    sha256 cellar: :any, high_sierra:    "66011c65d0a32036f58b67ae41ca6a61eb307bc92d958dec026f88e180cab972"
    sha256 cellar: :any, sierra:         "d2be4b1376fbeb90429433d0cae9b95b8b927701038156a7cb3d73a49620548f"
    sha256 cellar: :any, el_capitan:     "a87808f88a90308adfb14cf89b3bd89251580301f40ba18d08816de2df0be632"
    sha256 cellar: :any, yosemite:       "ec463b01aecec2cc76cd6f91761867fa0efbdeddf60f09bc134f45822006889b"
  end

  depends_on "boost"
  depends_on "gd"

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! "DESTDIR", prefix
      s.change_make_var! "CC", ENV.cc

      # don't chown/chgrp the installed files
      s.gsub! "-o 0 -g 0", ""

      # Use LDLIBS instead of LDFLAGS to ensure that library flags are specified in the correct order
      s.gsub! "LDFLAGS=", "LDLIBS="
    end

    # Explicitly refer to std::exception (not boost::exception)
    inreplace "mkhexgrid.cpp", "catch (exception &e)", "catch (std::exception &e)"

    # cstring header is needed for memset function
    inreplace "png.cpp", "#include <string>\n",
              "#include <string>\n#include <cstring>\n"

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
