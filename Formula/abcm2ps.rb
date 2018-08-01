class Abcm2ps < Formula
  desc "ABC music notation software"
  homepage "http://moinejf.free.fr"
  url "https://github.com/leesavide/abcm2ps/archive/v8.13.24.tar.gz"
  sha256 "12116ca374e4a71575bfd82a7a44e27e4bbdc7a0cbcc423b29ca3d5e149ab29b"

  bottle do
    sha256 "ab29f93e9f7d6a4afd699e400896cd7a0f17365ebfb33200659f4bf44babc929" => :high_sierra
    sha256 "f3450d1ceb89a4a85d90da5b6c3fa90103af56e2787e4aff59f95f39a9be1b3c" => :sierra
    sha256 "3b733c9bacf6d1966b4e7031ce841a1dfc4efeeae7d6d5c47ee291da3a8bea72" => :el_capitan
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
