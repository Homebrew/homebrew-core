class Iozone < Formula
  desc "File system benchmark tool"
  homepage "http://www.iozone.org/"
  url "http://www.iozone.org/src/current/iozone3_468.tar"
  sha256 "780801a4ce54503ea1060445497471b79bdb05db21338c77f96a5ac51ffac4ee"

  bottle do
    cellar :any_skip_relocation
    sha256 "8de42bd9a07de561ab96d8e8e1f5bb7e080e6b4b447e2530959c78dcd090cba6" => :sierra
    sha256 "d40abf2cadeefd00d48a82b4087a652a53e7b306b3ad87597293c24c352a36f7" => :el_capitan
  end

  def install
    cd "src/current" do
      system "make", "macosx", "CC=#{ENV.cc}"
      bin.install "iozone"
      pkgshare.install %w[Generate_Graphs client_list gengnuplot.sh gnu3d.dem
                          gnuplot.dem gnuplotps.dem iozone_visualizer.pl
                          report.pl]
    end
    man1.install "docs/iozone.1"
  end

  test do
    assert_match "File size set to 16384 kB",
      shell_output("#{bin}/iozone -I -s 16M")
  end
end
