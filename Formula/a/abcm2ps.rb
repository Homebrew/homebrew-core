class Abcm2ps < Formula
  desc "ABC music notation software"
  homepage "http://moinejf.free.fr"
  url "https://github.com/leesavide/abcm2ps/archive/refs/tags/v8.14.15.tar.gz"
  sha256 "5f02ac6203c4226cfbc6206935dca715ed7c45328535ee23e776c9da0219c822"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia:  "ec8cb5380cfee0043e5454ea122ff004c6366c19b06268edabf8af5f9481399f"
    sha256 arm64_sonoma:   "651079e5e1701bf7562d25ea288f60919cc4bc5389472bce8174a11460541dc7"
    sha256 arm64_ventura:  "737514da3b1e0c0ac7a2f7f1b0fb83707a6abcc167728bb5bbb812578595f86f"
    sha256 arm64_monterey: "e297a6005d7af043cd13bf9688e57c282a56ad9faede8f59c05adfddece2e6e7"
    sha256 sonoma:         "b8e39b5f623d4fbe99ebaa17b1b0100489fd05488df720889e08ac70e8090b2f"
    sha256 ventura:        "7d20976e8b6877400b712a6f341944c03920f498d781abfb009ad3d7cefba6f0"
    sha256 monterey:       "faaf0e3188a69245c09d790d31241ef2f057dffd94ff48b33463e2860fa0072f"
    sha256 x86_64_linux:   "cb486f3afb52ba110aa20878c5ac7b14bca9a1e4acd6b1a30fc4fd7741a55b93"
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

    system bin/"abcm2ps", testpath/"voices"
    assert_predicate testpath/"Out.ps", :exist?
  end
end
