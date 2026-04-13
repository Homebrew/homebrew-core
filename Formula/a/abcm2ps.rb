class Abcm2ps < Formula
  desc "ABC music notation software"
  homepage "http://moinejf.free.fr"
  url "https://chiselapp.com/user/moinejf/repository/abcm2ps/tarball/v8.14.18/download.tar.gz"
  sha256 "d1f1100b525f0f0ae00d706d0b4ebc01df279312b3b32cf20f355f1430f36c0a"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://chiselapp.com/user/moinejf/repository/abcm2ps/taglist"
    regex(%r{"tagDsp">v?(\d+(?:\.\d+)+)</span>}i)
  end

  bottle do
    sha256 arm64_tahoe:   "ad72e488f58816b605a868a4b62886e7da304c35c0147cc5d56d0903a8d950fd"
    sha256 arm64_sequoia: "218e1a99f51365c6127247efd11381714550ffbd3f28c142f59fc8aa52c76177"
    sha256 arm64_sonoma:  "9fd6fa884bb60b2ba984fff532d76ab6781b67bf85146a1800303a3cfdaf46fb"
    sha256 sonoma:        "616ecb66446b00f4eb9f0141663041a192f3c99c802f794a5b73751926d358c4"
    sha256 arm64_linux:   "2c295fe0316d1f77957df93a0f99c70ba2da1a1176f51b9e1901be03947d1063"
    sha256 x86_64_linux:  "cf383769496265b65b8cbf4f4f574f9db53f43b5946f246b6d6c2500dfc0fa78"
  end

  depends_on "pkgconf" => :build

  on_macos do
    depends_on "coreutils" => :build
    depends_on "gnu-sed" => :build
  end

  def install
    if OS.mac?
      ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin"
      ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin"
    end

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
