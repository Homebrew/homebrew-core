class Fairymax < Formula
  desc "AI for playing Chess variants"
  homepage "https://www.chessvariants.com/index/msdisplay.php?itemid=MSfairy-max"
  url "http://hgm.nubati.net/git/fairymax.git",
      tag:      "5.0b",
      revision: "f7a7847ea2d4764d9a0a211ba6559fa98e8dbee6"
  version "5.0b"
  head "http://hgm.nubati.net/git/fairymax.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "699b0ba8c10d2452add0b265cc336b835d61e4a2bc0ce00365519d8c3591e52c"
    sha256 arm64_ventura:  "7a431f623e9a7ffc4fe331a5ebe118265a9c0ade9222124516586591e0644286"
    sha256 arm64_monterey: "eb095e180e6f94ac2fa743df555fc7a8310f17034880868a8bc5605da3b0c681"
    sha256 sonoma:         "3ee1f7a3b2c6f44bdabd314a88e6c7a4b1556a743700d9c35fb593a928e5c3aa"
    sha256 ventura:        "bbf8bfbf45b9a08f721360217552ed277cb612f0878231b6dfc3b50dd84d6b43"
    sha256 monterey:       "ee474cd1bc1cdbfe55d9a4d2495bf43e8ea91675d23f6d86b583198b6ddfc026"
    sha256 x86_64_linux:   "7c129786c14d2eb245f90af3300ed059040a8057f5318302f024863516b05b43"
  end

  def install
    system "make", "install", "prefix=#{prefix}", "CC=#{ENV.cc}"
  end

  test do
    (testpath/"test").write <<~EOS
      hint
      quit
    EOS
    refute_match(/piece-description file .* not found/, shell_output("#{bin}/fairymax < test"))
  end
end
