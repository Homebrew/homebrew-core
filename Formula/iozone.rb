class Iozone < Formula
  desc "File system benchmark tool"
  homepage "http://www.iozone.org/"
  url "http://www.iozone.org/src/current/iozone3_469.tar"
  sha256 "0a200ec12a5b631ffb0973665f80ad563c4b00eac2e71f8acbb5176969bb5ea8"

  bottle do
    cellar :any_skip_relocation
    sha256 "5182985c07c2fcdcfd5e8096c2d175e6999e9a91cd3bfe54235e103340f7ee36" => :sierra
    sha256 "39b896d0dca83fffc160be9688514dd65b7d2ce9e593e8af465b5adeaa905241" => :el_capitan
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
