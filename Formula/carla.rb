class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v2.0.0.tar.gz"
  sha256 "d0c8d8417f8cce9abe807f6359231f187d60db7121ec1dccce3b596a22ef6c41"
  revision 3
  head "https://github.com/falkTX/Carla.git"

  bottle do
    cellar :any
    sha256 "145213abf29287173b35fb52a6f5cf81d57f5288c0b0c546d82564d14df15e22" => :catalina
    sha256 "bc4711cf9f85aa8a39621fc6230f7fde6c022be615fed5fdba7a45a4429ebada" => :mojave
    sha256 "eceaa5c7436b0f6d206fb40dedfe7cb36f2f83a3c8cd483723aa6db13a43ba50" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "liblo"
  depends_on "libmagic"
  depends_on "pyqt"
  depends_on "python@3.8"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    inreplace bin/"carla", "PYTHON=$(which python3 2>/dev/null)",
                           "PYTHON=#{Formula["python@3.8"].opt_bin}/python3"
  end

  test do
    system bin/"carla", "--version"
    system lib/"carla/carla-discovery-native", "internal", ":all"
  end
end
