class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v2.5.4.tar.gz"
  sha256 "251b5334bb86c84c85eddb541bfc68767d0fe422266e77df0c000b5b71fabb7e"
  license "GPL-2.0-or-later"
  head "https://github.com/falkTX/Carla.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6f04dc45e52855db5606394976e2f4eee1fff533658ee522e02dbe4bf517693b"
    sha256 cellar: :any,                 arm64_monterey: "3f5d78274bc3a3d710dc612735d8954401e514f6b221df5b798bbf34f0dc8c7e"
    sha256 cellar: :any,                 arm64_big_sur:  "e16eb0d6c7217dd2ca0158ae6dcbb59d68eb053f849f8074f6b8cca4e4ecf78d"
    sha256 cellar: :any,                 ventura:        "fdd2c31cf6e32b543439e553a6d99a6363225c827b62eaf42a020cfbb5fce317"
    sha256 cellar: :any,                 monterey:       "792ed455acbe919003d175556c58189dfb8caa99431ed7dfa4fcb2e97b43319f"
    sha256 cellar: :any,                 big_sur:        "6c723187538457cc11b67933b21487cd0eb4e7505516b163b062592b7542944c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52ef476e317692d51c3549bcfc9bf9a2f8ecbbe8e96a09d20d1d4bfdd2d81316"
  end

  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "liblo"
  depends_on "libmagic"
  depends_on "pyqt@5"
  depends_on "python@3.11"

  fails_with gcc: "5"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    inreplace bin/"carla", "PYTHON=$(which python3 2>/dev/null)",
                           "PYTHON=#{Formula["python@3.11"].opt_bin}/python3.11"
  end

  test do
    system bin/"carla", "--version"
    system lib/"carla/carla-discovery-native", "internal", ":all"
  end
end
