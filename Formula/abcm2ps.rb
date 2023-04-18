class Abcm2ps < Formula
  desc "ABC music notation software"
  homepage "http://moinejf.free.fr"
  url "https://github.com/leesavide/abcm2ps/archive/v8.14.14.tar.gz"
  sha256 "5b39ca08cd5e0d1992071b0be9eb77304489823824570236c4df4dc0f8b33aab"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "01a79191d06dbbe223a99a6a9bff533738f1be99c0a8619c272cced594e6fb61"
    sha256 arm64_monterey: "45912b99f3a665a401131e9ca982ca285eba96e7b22e35b5740f222b46687637"
    sha256 arm64_big_sur:  "b560ca5c750e672c8d1b257c827f362ddfbd0240c62a181737d4364d2ea3ebdd"
    sha256 ventura:        "098977e79f1f16813d4a62ff7852430a6780c96a7727803ef5410030a9931d05"
    sha256 monterey:       "59fa217929c0412dd51ad45601ee60b603277f4d42fd1e825191efe4843d8d64"
    sha256 big_sur:        "a84c64865bd9fa68fea198f3d84ae4214e3d5fd310ea230e8c55ba72ecf15e19"
    sha256 x86_64_linux:   "db401b9ff3506048d3a09a11fd9b59061f66cc94fc66904cd03bfcb301bf9e5c"
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
