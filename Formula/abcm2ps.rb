class Abcm2ps < Formula
  desc "ABC music notation software"
  homepage "http://moinejf.free.fr"
  url "http://moinejf.free.fr/abcm2ps-8.12.3.tar.gz"
  sha256 "d599a851b51e93659813445efe9b31177d62f779daffc9e5a67e67a5324789a6"

  bottle do
    sha256 "a0c6ba896397375c5063cf3b1ec25d566340ca5281f7163aa220dcf99a769d06" => :sierra
    sha256 "3e183cc2dfe424c125a685e9f56f1b1117e0651c0e4d99d34ecbd731dbd11da5" => :el_capitan
    sha256 "67466c3624affbaab9c9c8960eb8bf40e3d892ea19a17dd5ad61eac0a5374f68" => :yosemite
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
