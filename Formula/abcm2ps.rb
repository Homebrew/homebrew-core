class Abcm2ps < Formula
  desc "ABC music notation software"
  homepage "http://moinejf.free.fr"
  url "https://github.com/leesavide/abcm2ps/archive/v8.14.1.tar.gz"
  sha256 "c225e6d64a50cb983072ac316ad54a09870601174a47ffbcad3df951407307fe"

  bottle do
    sha256 "41127b10ca984ebd6b95e1236100f939d5e1fefbf5b443855a5f858cb28d3aed" => :mojave
    sha256 "f8b0c0c1958d0a26b777dd645b76b3342f7c7a34a54c8bb9b2f2d3200c681b88" => :high_sierra
    sha256 "5316afc94f0b6ebf721e23bbcf5e5012d7c952344cb9a39084f4295928d4e5eb" => :sierra
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
