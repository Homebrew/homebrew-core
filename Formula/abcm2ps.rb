class Abcm2ps < Formula
  desc "ABC music notation software"
  homepage "http://moinejf.free.fr"
  url "https://github.com/leesavide/abcm2ps/archive/v8.13.24.tar.gz"
  sha256 "12116ca374e4a71575bfd82a7a44e27e4bbdc7a0cbcc423b29ca3d5e149ab29b"

  bottle do
    sha256 "ddd68daf08fb2c73a15639e4fd1bbf1de24af003cb5b95698f702b2632287908" => :high_sierra
    sha256 "9cbece3d575efc3a8c40643562e5ea69062128f75439b1d0a617ed1370320153" => :sierra
    sha256 "bac5884aa3ab21ed04670d1ebc8890f4ec7e89cecfdaa505147e1266cf3182eb" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "pango" => :optional

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
