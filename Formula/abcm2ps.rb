class Abcm2ps < Formula
  desc "ABC music notation software"
  homepage "http://moinejf.free.fr"
  url "https://github.com/leesavide/abcm2ps/archive/v8.14.11.tar.gz"
  sha256 "e3b538d62face623619be46b9f7b7520c113fbb1b634073e1162d526adbf3f3b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 "2875a3976c83ad90ca731964fabfd916e19722e6529c8e980888af8bcaa3eabc" => :big_sur
    sha256 "7d4808a96ed60bd03b0630e089d4efe79f926c2fd040aa94de2ce7cd444e80c5" => :catalina
    sha256 "1d7083b0d688d338986406c21a4936d460e43233fe321afb020cc62d390b557b" => :mojave
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"voices.abc").write <<~EOS
      X:7
      T:Qui Tolis (Trio)
      C:Andre Raison
      M:3/4
      L:1/4
      Q:1/4=92
      %%staves {(Pos1 Pos2) Trompette}
      K:F
      %
      V:Pos1
      %%MIDI program 78
      "Positif"x3 |x3|c'>ba|Pga/g/f|:g2a |ba2 |g2c- |c2P=B  |c>de  |fga |
      V:Pos2
      %%MIDI program 78
              Mf>ed|cd/c/B|PA2d |ef/e/d |:e2f |ef2 |c>BA |GA/G/F |E>FG |ABc- |
      V:Trompette
      %%MIDI program 56
      "Trompette"z3|z3 |z3 |z3 |:Mc>BA|PGA/G/F|PE>EF|PEF/E/D|C>CPB,|A,G,F,-|
    EOS

    system "#{bin}/abcm2ps", testpath/"voices"
    assert_predicate testpath/"Out.ps", :exist?
  end
end
