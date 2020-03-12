class Fairymax < Formula
  desc "AI for playing Chess variants"
  homepage "https://www.chessvariants.com/index/msdisplay.php?itemid=MSfairy-max"
  url "http://hgm.nubati.net/git/fairymax.git",
      :tag      => "5.0b",
      :revision => "f7a7847ea2d4764d9a0a211ba6559fa98e8dbee6"
  version "5.0b"
  head "http://hgm.nubati.net/git/fairymax.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8dad1d34ed2ce478abebc9ac986bbf5d7d0bf7af5f8326839da735d8fb3d11c6" => :catalina
    sha256 "5c4d837d9726fd83661fac0703cda7829f2c81e48f69ac98016915f97dad15cf" => :mojave
    sha256 "7da2c1f0d3c9f8cdfd5729c22b16bb3a0c81e0189988e4afe43ccaa69518beda" => :high_sierra
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
