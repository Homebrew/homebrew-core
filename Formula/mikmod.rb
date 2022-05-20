class Mikmod < Formula
  desc "Portable tracked music player"
  homepage "https://mikmod.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mikmod/mikmod/3.2.8/mikmod-3.2.8.tar.gz"
  sha256 "dbb01bc36797ce25ffcab2b3bf625537b85b42534344e1808236ca612fbaa4cc"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/mikmod[._-](\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "bb54632a522875765adad5cab06af5329387f9ae1c5c7e96097ad7bc01e10526"
    sha256 arm64_big_sur:  "db291715ff28e243fcd0c1a5933bb5dc3c4bdf93368df9f66654d45e0003ea8c"
    sha256 monterey:       "e6722e94ac1051373437dd424178a21f821f1275c5fcc41547959549383364fc"
    sha256 big_sur:        "d36db8a1221871140e8053654f1dd7fd6433f7fa50e15b42b239137ede527cb8"
    sha256 catalina:       "6d6794da1daf749a56cf55738f796fe5b6a7b337456730b21a5efba2fab60f38"
    sha256 mojave:         "6812f223d67d763208eaf21ab6e1ebfaf50e349852cb6820010010ed0524b2f2"
    sha256 high_sierra:    "5907f92b40ddc0ba15cddd60269a9f9a8e9fcf6295a099df4145818536431427"
    sha256 sierra:         "a9586a9306006e8fd451aecb6c3259fc57cb0bb328a2b0ce8c064e5518f943bc"
    sha256 el_capitan:     "ae0b4480b6b34327b9c99601d7e2cbc9648ece54344bd4bda3582ef048e1f1de"
    sha256 yosemite:       "7d52131b792e01d3037dac4be52811744dfad23c2a11f4ee3d1985a8fb8f0331"
    sha256 x86_64_linux:   "4e4b77ce15ebf81c0bbaf79ca476bc05de760eaeedc28ffbfbcfdb33df94127d"
  end

  depends_on "libmikmod"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mikmod -V")
  end
end
