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
    sha256 "a6f0a32d9de27662d82b075d9bb59944a496c2782e5ce3e8b50228fbf48b1749" => :big_sur
    sha256 "4d23cb835d535b2b6a553e5e1bb1a9cceeba50745c45e97b53ce2057b9ef5d77" => :arm64_big_sur
    sha256 "a9865b6a1f2528acd3734a0833853a26a2b66c53c3f0e7f11be333a526c9d29d" => :catalina
    sha256 "9fd8e8232cb83eaeabc297ec4c89ec264e91fab8991d86c9aa57385f7143bf48" => :mojave
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
