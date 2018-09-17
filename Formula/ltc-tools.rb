class LtcTools < Formula
  desc "Tools to deal with linear-timecode (LTC)"
  homepage "https://github.com/x42/ltc-tools"
  url "https://github.com/x42/ltc-tools/archive/v0.6.4.tar.gz"
  sha256 "8fc9621df6f43ab24c65752a9fee67bee6625027c19c088e5498d2ea038a22ec"
  revision 1
  head "https://github.com/x42/ltc-tools.git"

  bottle do
    cellar :any
    sha256 "46463c437a233a0dbfb0b364a9dc460fd690e8af3fcd35693db3f300a9a03bee" => :mojave
    sha256 "9f0f16c105aeb4a59b421700c9bc3960eb4482aba07b0f9efa25098fcd4dc318" => :high_sierra
    sha256 "f56c26db84aa0873f46e8431dbee7cee0f6060955cdc9f7747899d0a6fa10604" => :sierra
    sha256 "3933abca95b5d7ec5c00222743963f3091464f4c0f577a51c35ca7cb11d57479" => :el_capitan
    sha256 "660401226bf452b88ef65a043577a0693bcdb7518ef885e5ea9d83d33da2bfbd" => :yosemite
  end

  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "jack"
  depends_on "libltc"
  depends_on "libsndfile"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"ltcgen", "test.wav"
    system bin/"ltcdump", "test.wav"
  end
end
