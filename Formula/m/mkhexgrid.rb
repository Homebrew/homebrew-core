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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "7e545dda93b7418fc133c0c9f5d28a9a72fa1f390601b23cd1d69cb2d67dcee2"
    sha256 cellar: :any,                 arm64_sequoia:  "66907e9872e7fa397d62e89974e7ad0abfb9a2dc527f25d32606e0d6a73e93f5"
    sha256 cellar: :any,                 arm64_sonoma:   "2714d9b761672dd9ce249a18f1b24d7d0a954574383107b7b048924d11587fd4"
    sha256 cellar: :any,                 arm64_ventura:  "f506ce3ff66554b2586a73404a1af6d811024842b254218b67f7aa421f699d9b"
    sha256 cellar: :any,                 arm64_monterey: "5b461772bb6b74ee5cc07db25a8baf6055941f93cba08946bb7174e024298e7d"
    sha256 cellar: :any,                 arm64_big_sur:  "488eb3b7fa3023c4326755bd7bd3546b926d3e03e353063d700c3f15c41e59f1"
    sha256 cellar: :any,                 sonoma:         "3f54c9d59ded252490c2a81aae8ddb0c90539b707dd0f81a27212bc49446fdb4"
    sha256 cellar: :any,                 ventura:        "213ee8b435eacf2f9bd1c50c8ba5a389ce3792c6a11626c0dbc3f8abca859469"
    sha256 cellar: :any,                 monterey:       "54d4b953eefd88048279f0742a636d343aa81cc1b077f4cffd40c57e1b49ceb9"
    sha256 cellar: :any,                 big_sur:        "ea516f25e28f2f0dae0223de16f1d27abd08f658ee85fb8caab7c41f02f3932b"
    sha256 cellar: :any,                 catalina:       "0e358685212d241af28055f0a47392bf077575469426e5bc4e38352847451325"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "77c7cc16e457e6287b0103e3ed7d2468aa87c6c49886ecac6b00651fad089bcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a52fcf963685daee9a1f8ab938b009639886dfb1f2a71cdf93969ff4a5d6bfc3"
  end

  depends_on "boost" => :build
  depends_on "gd"

  def install
    ENV.cxx11

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
    system bin/"mkhexgrid", "--output=ps", "--image-width=2448",
      "--image-height=1584", "--hex-side=36", "--coord-bearing=0",
      "--coord-dist=22", "--coord-size=8", "--grid-thickness=1",
      "--coord-font=Helvetica", "--grid-grain=h", "--grid-start=o",
      "--coord-tilt=-90", "--centered", "-o", "test.ps"
  end
end
