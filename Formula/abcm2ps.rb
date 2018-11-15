class Abcm2ps < Formula
  desc "ABC music notation software"
  homepage "http://moinejf.free.fr"
  url "https://github.com/leesavide/abcm2ps/archive/v8.14.1.tar.gz"
  sha256 "c225e6d64a50cb983072ac316ad54a09870601174a47ffbcad3df951407307fe"

  bottle do
    rebuild 1
    sha256 "916030cac1e06a0778317f14fa93a5e9f3d8144697349dbe51beca3a92b8ded2" => :mojave
    sha256 "ab2d24920675360fad9ddd431b028f72acca5ee9cf76a899ce96154ad166dae8" => :high_sierra
    sha256 "07bac275ad34c6a47de639320a483fb14996ccba82a4a8ee9b0a71e74274bcc0" => :sierra
    sha256 "15a01378cf025815839b464d2ebc5729072886e76e5b3d72e9bc480b3c7d4d32" => :el_capitan
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
