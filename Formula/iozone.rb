class Iozone < Formula
  desc "File system benchmark tool"
  homepage "http://www.iozone.org/"
  url "http://www.iozone.org/src/current/iozone3_482.tar"
  sha256 "2733feb63c96f77177c68f3d938f2294d5394d8554b2767c45cbe138b2f3ae30"

  bottle do
    cellar :any_skip_relocation
    sha256 "018eef36a5d786cada35067fe9ea7f07c9105714cacdc1499c5f00192c5fe7d7" => :mojave
    sha256 "62705cc571622d994f5613ee4883772cc72509ea3e05abe31cbc4777da6e7b57" => :high_sierra
    sha256 "e469596b5c9555e2eed85a8b2fe3aefa5a308d42c23bee66c2d0a79144fc669a" => :sierra
    sha256 "f4116538d4101eb4f62bb35d956de0c30f918b3028616c78bc69d66375e2bdc7" => :el_capitan
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
