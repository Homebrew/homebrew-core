class Abcm2ps < Formula
  desc "ABC music notation software"
  homepage "http://moinejf.free.fr"
  url "https://chiselapp.com/user/moinejf/repository/abcm2ps/tarball/v8.14.17/download.tar.gz"
  sha256 "61df2c53f932b9dbce57e1c6c4ff5be6e69ca2162317a7c3e61297befa40aeaa"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://chiselapp.com/user/moinejf/repository/abcm2ps/taglist"
    regex(%r{"tagDsp">v?(\d+(?:\.\d+)+)</span>}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "009998c0673285fe186b142ba9dfdf7e6da03baa621fed30626e0c208526e9a5"
    sha256 arm64_sequoia: "3d17a30a50dec0a222b5affc869944133110d26183456da63dd0e53ed05dced0"
    sha256 arm64_sonoma:  "1285f979079ab7e11a7b9695ca1a50e558bd1e98ea77fc7b0eade685bd339e78"
    sha256 arm64_ventura: "b1904fe9f5fb66c73cba6bf1988afdc0a86ba846972738e649a2c9b1c1e6268d"
    sha256 sonoma:        "e89ffe353ec57c1e6203ea927ad2234bac3cd90b49daba91bec849cc29acbb24"
    sha256 ventura:       "c7d963e4b54d64a7277ea51e0f9c52b6d522b24affbdd70b4820a7e2dba88eda"
    sha256 arm64_linux:   "1d02bfb62f29fc77d202476f9848e39520045d0b495b215859c3bfe294388fc8"
    sha256 x86_64_linux:  "f68c9955212b1f0ece80488663bb67ba04dfca697c6c417f339caa2a625c2413"
  end

  depends_on "pkgconf" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"voices.abc").write <<~ABC
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
    ABC

    system bin/"abcm2ps", testpath/"voices"
    assert_path_exists testpath/"Out.ps"
  end
end
