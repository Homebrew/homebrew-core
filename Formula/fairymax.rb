class Fairymax < Formula
  desc "AI for playing Chess variants"
  homepage "http://www.chessvariants.org/index/msdisplay.php?itemid=MSfairy-max"
  url "http://hgm.nubati.net/git/fairymax.git", :tag => "4.8V", :revision => "b12e1192005c781f64ed9c25c9825d20384d2468"
  version "4.8V"
  head "http://hgm.nubati.net/git/fairymax.git"

  bottle do
    sha256 "452353f678194a579cf910183f0a147ebfdfe30fc48bd29f7d0499f53c25fdca" => :yosemite
    sha256 "8d18b3bb91fd8d4158e7f074a0585256842a6c4d86a2ae8911b35271d86f2218" => :mavericks
    sha256 "7fa32e1ece7c7b0d3b8b18765a7377eaae1218fff9521d1e523cbe275ecc6435" => :mountain_lion
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
    (testpath/"test").write <<-EOS.undent
      hint
      quit
    EOS
    system "#{bin}/fairymax < test"
  end
end
