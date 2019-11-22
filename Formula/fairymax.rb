class Fairymax < Formula
  desc "AI for playing Chess variants"
  homepage "https://www.chessvariants.com/index/msdisplay.php?itemid=MSfairy-max"
  url "http://hgm.nubati.net/git/fairymax.git",
      :tag      => "4.8V",
      :revision => "b12e1192005c781f64ed9c25c9825d20384d2468"
  version "4.8V"
  head "http://hgm.nubati.net/git/fairymax.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0e308c9dd845afa291091336b0e92e44e8a38e59400b2801ed55c69ae36a3cfb" => :catalina
    sha256 "41aa62f81177b236fe5555b0ed48ec704eef68850e4b9f9edf33a5ff76168a72" => :mojave
    sha256 "513860ba4079904f6244eb1ab92ed8362be17080a871dab9711c75e7ee14e21a" => :high_sierra
  end

  def install
    system "make", "all",
                   "INI_F=#{pkgshare}/fmax.ini",
                   "INI_Q=#{pkgshare}/qmax.ini"
    bin.install "fairymax", "shamax", "maxqi"
    pkgshare.install Dir["data/*.ini"]
    man6.install "fairymax.6.gz"
  end

  test do
    (testpath/"test").write <<~EOS
      hint
      quit
    EOS
    system "#{bin}/fairymax < test"
  end
end
