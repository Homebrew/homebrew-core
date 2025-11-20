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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "1d0639d384ade218845be170da852cfc449bd37d136857ed765e42af992ca260"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e37b7f219ffcd93287b959d108fd79cf870a3e980f989962a8e7edd8b3d90106"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f7b1c26df867fb0e9031c525710cdc3e3cab06f1885f8da99ed41753eee0735"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81ac6e08be5d5bcdeb1fe53b6ae9967662fc31fcb18cd9de9a8758ced4a1d3a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d14f5dd7a1e4f7e441e94d5c43f7786169190125da84e1b425005c79164e55d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebb88262f3ba1eb8196c8821769298b4aa29bb4c5d0733fc8dcd47092cfafdd5"
    sha256 cellar: :any_skip_relocation, sonoma:         "098e6dc6a470fdc2fdcb12612036c40e9ad5775cf301986220911865cc102638"
    sha256 cellar: :any_skip_relocation, ventura:        "0f0471f80fe9004fd5c0028ffc6ab8b5b5240474a5b04533b5d53104e732d7a8"
    sha256 cellar: :any_skip_relocation, monterey:       "a6c032a31a38ab8d086b20944fd5b4e3bf074ecaca2f7d593897fd5deb19e250"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5e52d02125f49b9c5afc960a565f7f5a774ced3f88fabd07d2723e741369d82"
    sha256 cellar: :any_skip_relocation, catalina:       "4f70eb02805d1fe2a93dc169b9baf2a3d1c685ded71094241189c93599ba6662"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9d8c26e4f4fec89140d5ec6261d115ce6d7ab076c7ce1f42fc16c6cb60f645fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cfece9c5d6614f0c1139161f6ca6ced317514cc45a7b13d06ecf0316b53656f"
  end

  uses_from_macos "ncurses"

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/mp3info/patch-mp3tech.c.diff"
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
