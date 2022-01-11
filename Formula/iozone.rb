class Iozone < Formula
  desc "File system benchmark tool"
  homepage "https://www.iozone.org/"
  url "https://www.iozone.org/src/current/iozone3_493.tgz"
  sha256 "5a52f5017e022e737f5b55f320cc6ada0f2a8c831a5f996cce2a44e03e91c038"
  license :cannot_represent

  livecheck do
    url "https://www.iozone.org/src/current/"
    regex(/href=.*?iozone[._-]?v?(\d+(?:[._]\d+)+)\.t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub("_", ".") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1cbd65256b4194b9433684790fa8de0cbda60969381c091ed4b0d1c5ca80f85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70162e3f4b8b8c9729b677e44f99d75c29c3bed2eff7a3048a4a9742ead8f2af"
    sha256 cellar: :any_skip_relocation, monterey:       "0bed94ffcb0544a55c470ac0ff8c01434bdc2a9c18ccc55a7daf058a3b242661"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe98259ce6b004cb083aca24b7667b67b561b5ca88721c270f4fa233356ad9af"
    sha256 cellar: :any_skip_relocation, catalina:       "7dc593ccc4ac2845d72b664ae50edb58b1bfb3552fae8a26af0bcb0b46926cbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52188213e65cf7e644bdc743d74049bb8797c05eaed8ffa30e94b21207ddd5c5"
  end

  def install
    cd "src/current" do
      target = OS.mac? ? "macosx" : OS.kernel_name.downcase
      system "make", target, "CC=#{ENV.cc}"
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
