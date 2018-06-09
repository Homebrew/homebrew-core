class Iozone < Formula
  desc "File system benchmark tool"
  homepage "http://www.iozone.org/"
  url "http://www.iozone.org/src/current/iozone3_482.tar"
  sha256 "2733feb63c96f77177c68f3d938f2294d5394d8554b2767c45cbe138b2f3ae30"

  bottle do
    cellar :any_skip_relocation
    sha256 "326016c0bf55e8650a5a7eed5797f11c1affec8510bb133d36c76c53cc2b9a24" => :high_sierra
    sha256 "45575a80a9439747f4eab5f43183863102021cc8a6847b45d5e28993a705b5c6" => :sierra
    sha256 "d36b0574e9c79c92f1de61db3516dbe50377438842f2d61234108a13e38c8a35" => :el_capitan
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
