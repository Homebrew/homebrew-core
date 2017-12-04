class Abcm2ps < Formula
  desc "ABC music notation software"
  homepage "http://moinejf.free.fr"
  url "https://github.com/leesavide/abcm2ps/archive/v8.13.17.tar.gz"
  sha256 "639755b7760ddb3f293ab686b23ff7d5937df13f1c388d08e34ceaee319249e9"

  bottle do
    sha256 "4cc941a6caa74f2b2c0f7e816a657cbda6abaa6d9d8e20cb7bc36ffcc13dcbe5" => :high_sierra
    sha256 "0555a472b5890f8e8b94c006a1a0a3bce5d071cbf1980cb8bbbeee2ec493c712" => :sierra
    sha256 "bafc1ac9344bfc05ab4574addb4010e9089854792863873f08e60944347cad70" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "pango" => :optional

  def install
    chmod 0755, "configure" # remove for > 8.13.15
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
