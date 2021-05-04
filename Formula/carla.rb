class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v2.3.0.tar.gz"
  sha256 "27def29cc408d5c74926e8d0ef3a77fd76fee1e4f2797f840e999e6376a5be03"
  license "GPL-2.0-or-later"
  head "https://github.com/falkTX/Carla.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, big_sur:  "f8ee9fd5b1230b0e4b8e447969a420534d63f735758d21acdea0f52713b4f29a"
    sha256 cellar: :any, catalina: "3d507dc32add60b1a0eb60eb0cb27fcfa352789c63133229d7881dedaf86779d"
    sha256 cellar: :any, mojave:   "6d4f42afcb7a94322b8509db1a44dd8859cb46b3c0adda2efa103f4115032a9d"
  end

  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "liblo"
  depends_on "libmagic"
  depends_on "pyqt@5"
  depends_on "python@3.9"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    inreplace bin/"carla", "PYTHON=$(which python3 2>/dev/null)",
                           "PYTHON=#{Formula["python@3.9"].opt_bin}/python3"
  end

  test do
    system bin/"carla", "--version"
    system lib/"carla/carla-discovery-native", "internal", ":all"
  end
end
