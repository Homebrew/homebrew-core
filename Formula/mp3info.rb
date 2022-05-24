class Mp3info < Formula
  desc "MP3 technical info viewer and ID3 1.x tag editor"
  homepage "https://www.ibiblio.org/mp3info/"
  url "https://www.ibiblio.org/pub/linux/apps/sound/mp3-utils/mp3info/mp3info-0.8.5a.tgz"
  sha256 "0438ac68e9f04947fb14ca5573d27c62454cb9db3a93b7f1d2c226cd3e0b4e10"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.ibiblio.org/pub/linux/apps/sound/mp3-utils/mp3info/"
    regex(/href=.*?mp3info[._-]v?(\d+(?:\.\d+)+(?:[._-]?[a-z]\d*)?)\.(t|zip)/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d14f5dd7a1e4f7e441e94d5c43f7786169190125da84e1b425005c79164e55d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebb88262f3ba1eb8196c8821769298b4aa29bb4c5d0733fc8dcd47092cfafdd5"
    sha256 cellar: :any_skip_relocation, monterey:       "a6c032a31a38ab8d086b20944fd5b4e3bf074ecaca2f7d593897fd5deb19e250"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5e52d02125f49b9c5afc960a565f7f5a774ced3f88fabd07d2723e741369d82"
    sha256 cellar: :any_skip_relocation, catalina:       "4f70eb02805d1fe2a93dc169b9baf2a3d1c685ded71094241189c93599ba6662"
    sha256 cellar: :any_skip_relocation, mojave:         "74e04cc5b66e44632a9f3187f2360eba1f1f13ea153f7c6e4e0b4e466f58f084"
    sha256 cellar: :any_skip_relocation, high_sierra:    "9b966553a2ed76afb888577cad6ae8f359cde30e445bb0742a87ff2c5d5dfa85"
    sha256 cellar: :any_skip_relocation, sierra:         "dd9e2ab142307a9587ca28f8ca574cf3115f380f2692f1eb1e38e24d4e5a1008"
    sha256 cellar: :any_skip_relocation, el_capitan:     "30c85d8b2afd6e6ad03e473de3bd83ef9c6c607b979570798cfc778ad887b902"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cfece9c5d6614f0c1139161f6ca6ced317514cc45a7b13d06ecf0316b53656f"
  end

  uses_from_macos "ncurses"

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/bedf6f8/mp3info/patch-mp3tech.c.diff"
    sha256 "846d6f85a3fa22908c6104436e774fc109547f7c6e9788c15dd9e602228b7892"
  end

  def install
    system "make", "mp3info", "doc"
    bin.install "mp3info"
    man1.install "mp3info.1"
  end

  test do
    system bin/"mp3info", "-x", test_fixtures("test.mp3")
  end
end
