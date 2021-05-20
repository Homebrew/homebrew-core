class Iozone < Formula
  desc "File system benchmark tool"
  homepage "https://www.iozone.org/"
  url "https://www.iozone.org/src/current/iozone3_491.tgz"
  sha256 "efeea0e84ccd9b92920c60e2668caf6ef595c5d95e6cea89760a62eb64365df8"
  license :cannot_represent
  revision 1

  livecheck do
    url "https://www.iozone.org/src/current/"
    regex(/href=.*?iozone[._-]?v?(\d+(?:[._]\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4d23cb835d535b2b6a553e5e1bb1a9cceeba50745c45e97b53ce2057b9ef5d77"
    sha256 cellar: :any_skip_relocation, big_sur:       "a6f0a32d9de27662d82b075d9bb59944a496c2782e5ce3e8b50228fbf48b1749"
    sha256 cellar: :any_skip_relocation, catalina:      "a9865b6a1f2528acd3734a0833853a26a2b66c53c3f0e7f11be333a526c9d29d"
    sha256 cellar: :any_skip_relocation, mojave:        "9fd8e8232cb83eaeabc297ec4c89ec264e91fab8991d86c9aa57385f7143bf48"
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
