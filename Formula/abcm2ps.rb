class Abcm2ps < Formula
  desc "ABC music notation software"
  homepage "http://moinejf.free.fr"
  url "http://moinejf.free.fr/abcm2ps-8.12.3.tar.gz"
  sha256 "d599a851b51e93659813445efe9b31177d62f779daffc9e5a67e67a5324789a6"

  bottle do
    sha256 "0353ba288d12400e8cb5e1818ed1400e8107f455f2b0fafa20adac54a20c9222" => :el_capitan
    sha256 "bae92578812b0349a39612c953667d378a31bc5b84636e8332f10d3d3dc40775" => :yosemite
    sha256 "2ea6b8d99886a878aff3fbe32fea172ee384eda15b245c2fdc8c636a89ea4834" => :mavericks
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
