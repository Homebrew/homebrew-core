class Abcm2ps < Formula
  desc "ABC music notation software"
  homepage "http://moinejf.free.fr"
  url "https://github.com/leesavide/abcm2ps/archive/v8.14.13.tar.gz"
  sha256 "8db29e33f30fce609ddffeb641c3bfe60ae5d16c3305402157ddc88bcaaf0c5b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "66fc98754086e61de352bde7d193516ad03ab7dba6acad7819448d90d8cf1e4a"
    sha256 arm64_big_sur:  "d7acbc60c7dfc12b7f2d915cd2e4f694fc4cb1e54eb32d561a2a2e3c03cb8e0b"
    sha256 monterey:       "1dbdf6fc8c90837550bb710d97c546cfe8b8d0a2b37d54086c24a232bffed044"
    sha256 big_sur:        "07759b5ddeab313116502465116dfe940718c71dfd0867bad82b6d8457537ce7"
    sha256 catalina:       "c50589d7f7cdf5a0ad7cf8468c619a64f0fd3a801803aeb727e9beaee2fa04d3"
    sha256 x86_64_linux:   "6ba0c5819c9058230e8af293302616c42aa07a04e0ab2cfb1f3934ceba8a846c"
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
