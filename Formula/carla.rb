class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v2.0.0.tar.gz"
  sha256 "d0c8d8417f8cce9abe807f6359231f187d60db7121ec1dccce3b596a22ef6c41"
  head "https://github.com/falkTX/Carla.git"

  bottle do
    cellar :any
    sha256 "a39e18a5d4607940f90a6a32efc29fa82ec626995fe93354a85f248c63e65c2a" => :mojave
    sha256 "24e9a7ac065d312ad4911dd663befc3abadc020a239f013345cfd6b3bfac2c4e" => :high_sierra
    sha256 "2ce1ae9b9971999d046e84523807da278fbd67dedfcc5282b7e0965880980cd5" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "liblo"
  depends_on "libmagic"
  depends_on "pyqt"
  depends_on "python"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"carla", "--version"
    system lib/"carla/carla-discovery-native", "internal", ":all"
  end
end
