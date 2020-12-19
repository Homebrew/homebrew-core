class Iozone < Formula
  desc "File system benchmark tool"
  homepage "http://www.iozone.org/"
  url "http://www.iozone.org/src/current/iozone3_491.tgz"
  sha256 "057d310cc0c16fcb35ac6de25bee363d54503377cbd93a6122797f8277aab6f0"
  license :cannot_represent

  livecheck do
    url "http://www.iozone.org/src/current"
    regex(/href=.*?iozone[._-]?v?(\d+(?:[._]\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7cf1ce68a46a5adef9dfa6b798551ef7cf362fcdc40530e9a44097ec8139de16" => :big_sur
    sha256 "129e22fb6b081c7deaf445510f8f0d93e6c8d1a9ae695ad3dcee41d5fcf381ab" => :catalina
    sha256 "1e771d45e93a3302432d01667f4bc14c038e7bdcf20276de495ba53cb06d0b2b" => :mojave
    sha256 "9c6d55de1e8794b696762880a289bde9dea1e5f79b3bda5411b6535f8aa7e9a0" => :high_sierra
  end

  def install
    cd "src/current" do
      on_macos do
        system "make", "macosx", "CC=#{ENV.cc}"
      end
      on_linux do
        system "make", "linux", "CC=#{ENV.cc}"
      end
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
