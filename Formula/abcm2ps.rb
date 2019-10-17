class Abcm2ps < Formula
  desc "ABC music notation software"
  homepage "http://moinejf.free.fr"
  url "https://github.com/leesavide/abcm2ps/archive/v8.14.5.tar.gz"
  sha256 "09bc9d6df221521ae4ad70a5721552a6d443ab1df29193c732f45854f88ad7c0"

  bottle do
    sha256 "3a19c545dd083dfec931155ff9e329df904ceed365cb0d3e99d1f3115200d664" => :catalina
    sha256 "18f4f1bf474fb2e9c928143748adbe006039eb19ca1f5c10c813724266259c59" => :mojave
    sha256 "b44fecce969653acece26c73ce21ac0f81592ce7435c6413d3c5b260cc58cf88" => :high_sierra
    sha256 "0ee03d6f973cc74b0611ae7867f94fa24168ba236422728342ab2bd60b9231bd" => :sierra
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
