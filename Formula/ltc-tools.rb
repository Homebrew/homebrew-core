class LtcTools < Formula
  desc "Tools to deal with linear-timecode (LTC)"
  homepage "https://github.com/x42/ltc-tools"
  url "https://github.com/x42/ltc-tools/archive/v0.6.4.tar.gz"
  sha256 "8fc9621df6f43ab24c65752a9fee67bee6625027c19c088e5498d2ea038a22ec"
  head "https://github.com/x42/ltc-tools.git"
  revision 1

  bottle do
    cellar :any
    sha256 "f56c26db84aa0873f46e8431dbee7cee0f6060955cdc9f7747899d0a6fa10604" => :sierra
    sha256 "3933abca95b5d7ec5c00222743963f3091464f4c0f577a51c35ca7cb11d57479" => :el_capitan
    sha256 "660401226bf452b88ef65a043577a0693bcdb7518ef885e5ea9d83d33da2bfbd" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "help2man" => :build
  depends_on "libltc"
  depends_on "libsndfile"
  depends_on "jack"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"ltcgen", "test.wav"
    system bin/"ltcdump", "test.wav"
  end
end
