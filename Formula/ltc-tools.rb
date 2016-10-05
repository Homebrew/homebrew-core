class LtcTools < Formula
  desc "Tools to deal with linear-timecode (LTC)"
  homepage "https://github.com/x42/ltc-tools"
  url "https://github.com/x42/ltc-tools/archive/v0.6.4.tar.gz"
  sha256 "8fc9621df6f43ab24c65752a9fee67bee6625027c19c088e5498d2ea038a22ec"
  head "https://github.com/x42/ltc-tools.git"

  bottle do
    cellar :any
    sha256 "659226a125668939abb2c8e2b89e18ae2805d225e9b7295af83adfbb4b2b00a5" => :sierra
    sha256 "b3b9a4d9f9969a81be3aa7a51b35a8c1f61a0c7b839fe3778a9665996faa4925" => :el_capitan
    sha256 "e3bb3cca684ddf01e1d6e8f1830609a3de22a8cc654d29db959dccd211766489" => :yosemite
    sha256 "12b8773c9045c5b3e8c5d57f085e02ee078f4807f8fc0b868c5d2eee99b5ea49" => :mavericks
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
