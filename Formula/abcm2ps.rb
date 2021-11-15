class Abcm2ps < Formula
  desc "ABC music notation software"
  homepage "http://moinejf.free.fr"
  url "https://github.com/leesavide/abcm2ps/archive/v8.14.12.tar.gz"
  sha256 "f98701bc25f52e98a9283d0cef04591351b62ff8dc80fa54bb21467d60886feb"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "54e41f320c0fbc125d40719d1f20d2921189d39232329e072b59439c18d2f7e1"
    sha256 arm64_big_sur:  "42abb1e6c0889e0954242008cc5fd30c84f627e4e518b6be27703853845c0672"
    sha256 monterey:       "c76e4417eb1b27de4f18b7472aa7a47aaa1a3debdd6203b3e7cdd18db33fc962"
    sha256 big_sur:        "144623cb4260d663db5784b43ba99c2d5aa0edf37929c4ac2d8b95ddde58fb8c"
    sha256 catalina:       "ec684f5aaf53d8a83439b0dcc59d4cedec82083713d97394391e8d2fa182b14e"
    sha256 mojave:         "0fdb3f48ed874b1c5e7797db126bbbb19baf6567dd0677569c69795459dfa431"
    sha256 x86_64_linux:   "f2cac2669a5cb1a506d6506abdcc9834eaa17efd991c769e5273b0fbe7950456"
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
