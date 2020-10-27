class Abcm2ps < Formula
  desc "ABC music notation software"
  homepage "http://moinejf.free.fr"
  url "https://github.com/leesavide/abcm2ps/archive/v8.14.9.tar.gz"
  sha256 "9d91c215d59bb3704fe174ba0729f634e656ab42210cfabf02f0c5c4e0c9d877"
  license "GPL-3.0"

  bottle do
    sha256 "c67da1ca155904d0794fc458add9bd5cd4a446a212e3aef790083c68e9aef252" => :catalina
    sha256 "2d592b6fae0b8b94a63cc297f0e29e6c155019f17a830151c341376dcc9d7f6e" => :mojave
    sha256 "c11af5280e03a986554b9eafa4f2cd0dc91cb725dd35e81228eaf8d126c9660f" => :high_sierra
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
