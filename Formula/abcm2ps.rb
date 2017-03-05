class Abcm2ps < Formula
  desc "ABC music notation software"
  homepage "http://moinejf.free.fr"
  url "http://moinejf.free.fr/abcm2ps-8.13.7.tar.gz"
  sha256 "00b7704c512c0db4a747050ec93d4b13e16c50798cff375e2c809a6144dcafc5"

  bottle do
    sha256 "57ac25149206f8a2d5560b212feb59bbbcca8c23f42bcbc5802d7e7df5970320" => :sierra
    sha256 "aea7af1f642170c7d4c955d78cf78ab3db1187e073aec270ed18506b1cf8d3ec" => :el_capitan
    sha256 "8888e88bb7ca2c3ef5ed46a286e14a8b5f8b64111b4b689ef3e958620dd7b952" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "pango" => :optional

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"voices.abc").write <<-EOF.undent
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
    EOF

    system "#{bin}/abcm2ps", testpath/"voices"
    assert File.exist?("Out.ps")
  end
end
