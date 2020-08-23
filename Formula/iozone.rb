class Iozone < Formula
  desc "File system benchmark tool"
  homepage "http://www.iozone.org/"
  url "http://www.iozone.org/src/current/iozone3_490.tar"
  sha256 "5eadb4235ae2a956911204c50ebf2d8d8d59ddcd4a2841a1baf42f3145ad4fed"

  bottle do
    cellar :any_skip_relocation
    sha256 "129e22fb6b081c7deaf445510f8f0d93e6c8d1a9ae695ad3dcee41d5fcf381ab" => :catalina
    sha256 "1e771d45e93a3302432d01667f4bc14c038e7bdcf20276de495ba53cb06d0b2b" => :mojave
    sha256 "9c6d55de1e8794b696762880a289bde9dea1e5f79b3bda5411b6535f8aa7e9a0" => :high_sierra
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
