class Abcm2ps < Formula
  desc "ABC music notation software"
  homepage "http://moinejf.free.fr"
  url "https://github.com/leesavide/abcm2ps/archive/v8.14.5.tar.gz"
  sha256 "09bc9d6df221521ae4ad70a5721552a6d443ab1df29193c732f45854f88ad7c0"

  bottle do
    sha256 "69bec8680e6e76714977d28b02d01545824c6e3c551589f189b2f941f964ac5e" => :mojave
    sha256 "03b600243e0b6700e16d064c2332a7556ffb25d12a8544475cfb3ee14c05a507" => :high_sierra
    sha256 "f6e131e82457d8e836d60dec364456926be89ac8d05fa287893d25be1f502791" => :sierra
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
