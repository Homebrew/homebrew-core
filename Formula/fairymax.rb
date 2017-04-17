class Fairymax < Formula
  desc "AI for playing Chess variants"
  homepage "https://www.chessvariants.com/index/msdisplay.php?itemid=MSfairy-max"
  url "http://hgm.nubati.net/git/fairymax.git", :tag => "4.8V", :revision => "b12e1192005c781f64ed9c25c9825d20384d2468"
  version "4.8V"
  head "http://hgm.nubati.net/git/fairymax.git"

  bottle do
    sha256 "95706f3f4968922cffae144d91e64d26a4c88026f228d555f144a4ad27c37007" => :sierra
    sha256 "9a829afcded25d1e895e09e91e39ca44b4aa9a6fa97f5315e348228224765d7d" => :el_capitan
    sha256 "b236b3da5f94128741b7ef25407f5a8a30158e108e9010736fee51df3f557195" => :yosemite
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
