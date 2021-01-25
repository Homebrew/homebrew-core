class Abcm2ps < Formula
  desc "ABC music notation software"
  homepage "http://moinejf.free.fr"
  url "https://github.com/leesavide/abcm2ps/archive/v8.14.11.tar.gz"
  sha256 "e3b538d62face623619be46b9f7b7520c113fbb1b634073e1162d526adbf3f3b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 "576ceb67099499b4456a08434a9638a792eee8d12df2db9d957c80a48fb004e3" => :big_sur
    sha256 "5a56794cc9fa9e49f3c8850f94ef7f1954832cfb6a0df0444b534e63b77962ba" => :arm64_big_sur
    sha256 "294a1b897cd3224cfb9c03053c9a7826c9e7cdbe07065ff17f5f9a9f1608a0f8" => :catalina
    sha256 "5bbc737b7c7b864e6490431cab5359b6193b75faa23ac6d5b5a1d78eda906b1c" => :mojave
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
