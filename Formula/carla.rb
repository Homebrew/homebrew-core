class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v2.5.5.tar.gz"
  sha256 "e5958982b6f73d946db2334d275377a06e979e607bce7ae91738dd939cd0ee55"
  license "GPL-2.0-or-later"
  head "https://github.com/falkTX/Carla.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3f74173b7813d51fec7aaf81dd94fb100e9b73e25b0accdfcb96640d5e943438"
    sha256 cellar: :any,                 arm64_monterey: "c91e7c711ce4eea2cdd6a057a05fca227d868b0d3941663c7b156e28667da9a5"
    sha256 cellar: :any,                 arm64_big_sur:  "d0a631f48032017169293e6bc452f012c48398e36a987f418f766dc3644f27bd"
    sha256 cellar: :any,                 ventura:        "e15817c0707d00c4ac4c9b9ccbb310b0a8abb76496d76fe2ccc06aa6b8537628"
    sha256 cellar: :any,                 monterey:       "f1f3d0d01e2daab52209918b9f7845d3f490e33489bde5214b2275ca3b461f29"
    sha256 cellar: :any,                 big_sur:        "856780a2e3db366485fd44aed439329038ac0b3fe4abc7df73f2c79d6f010e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "159912db28e49cadc5c2158f5e48003a80f6310d3cfa21747699808e12a2c8a7"
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
