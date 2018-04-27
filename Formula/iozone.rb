class Iozone < Formula
  desc "File system benchmark tool"
  homepage "http://www.iozone.org/"
  url "http://www.iozone.org/src/current/iozone3_478.tar"
  sha256 "47517c0dcb4cab80b5ff46dd72ecd60e806ba36b751d9d2faabeb6734b1235b7"

  bottle do
    cellar :any_skip_relocation
    sha256 "125a19509391f0536e27c751db1311a8489f301ef8de468efd24f7d55e6ec142" => :high_sierra
    sha256 "7ba3bb6a7e6ef01b3cf1c69944e7e2b5ecfd907b65eaf0b92b1bea39aa3af780" => :sierra
    sha256 "5e9abfbc2ce0664ad14a116e7e3995e99e02109bb687749d627a69fcb06af706" => :el_capitan
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
