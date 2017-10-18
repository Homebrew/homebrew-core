class Abcm2ps < Formula
  desc "ABC music notation software"
  homepage "http://moinejf.free.fr"
  url "https://github.com/leesavide/abcm2ps/archive/v8.13.15.tar.gz"
  sha256 "8a258efbd1f4c2776ea03bfd154a61a49599eeeaaa8c4e0ac8f84e0c0bb4f136"

  bottle do
    sha256 "3d8f321c18b99ec290961b8c7834b70b66f51e0270d2b470e91e7c1bc3a84a53" => :high_sierra
    sha256 "97a4b2437c3b7b7b8f9ffb5007bb8f5231d845e054c3ba82559824919985e3ad" => :sierra
    sha256 "3544a462d9f01a4b448e74873cf08de16d408b20779eb89dffb20b71a47fb93b" => :el_capitan
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
