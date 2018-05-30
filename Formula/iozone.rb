class Iozone < Formula
  desc "File system benchmark tool"
  homepage "http://www.iozone.org/"
  url "http://www.iozone.org/src/current/iozone3_479.tar"
  sha256 "459343b77fa0c7bac23cd242e1233a27745a3f8e2f8e3981990a1b8a6579dfd5"

  bottle do
    cellar :any_skip_relocation
    sha256 "f695c668b322794f067c2c333f332073d0a14877cd611fa0880c47276643b048" => :high_sierra
    sha256 "43164b675e0019918cbc8661eedd37682e6c2167aad8ce4408e8c2dc80ab9d45" => :sierra
    sha256 "1d7e34cd91861d25a446ecc5f14106fe189ada84eb2bfc0da61b6daf1d1ae838" => :el_capitan
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
