class Iozone < Formula
  desc "File system benchmark tool"
  homepage "http://www.iozone.org/"
  url "http://www.iozone.org/src/current/iozone3_481.tar"
  sha256 "d077e6c6ed50fe1514f8adc4b1e77eb684be8b5446bdb464dba439b8b10a51a4"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a97c328f1b34f9498b65970a59c6efe27746f9cd470dd0673c289338d1aa7f2" => :high_sierra
    sha256 "5bb8a10359af9b1d413bd352a4f152bff92224f6f22af35f29300d4125a61d7c" => :sierra
    sha256 "e406605535eed31d0d5d2063971378ba07c0f89b0e048d5988399d92dba9a920" => :el_capitan
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
