class Abcm2ps < Formula
  desc "ABC music notation software"
  homepage "http://moinejf.free.fr"
  url "https://github.com/leesavide/abcm2ps/archive/v8.13.14.tar.gz"
  sha256 "89c4af97ae9448c055e9a7d48a6645e909f2895d3724a47ec4c39e91d125375e"

  bottle do
    sha256 "8b59763c4f1b83e48fbe5a522cba9ebf94a75f1eb8d036db3c48ecde5ba6ee3d" => :sierra
    sha256 "0a4e57ccc1eb622ccdb834b6e5b6cdb0d9a7f0a5cab86df202ef58f55ba4adc8" => :el_capitan
    sha256 "958dad06cf33a032909d7e5b66eab4e9cf8072e0a5590430a8b1fe82b7a3d25d" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "pango" => :optional

  def install
    chmod 0755, "configure" # remove for > 8.13.14
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
