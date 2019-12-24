class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v2.0.0.tar.gz"
  sha256 "d0c8d8417f8cce9abe807f6359231f187d60db7121ec1dccce3b596a22ef6c41"
  revision 2
  head "https://github.com/falkTX/Carla.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "619903bfafcd1e6871b17507cec571c1caa33555f79235e3385aad8e2fd75087" => :catalina
    sha256 "811e984b6f6c4daf2593ce51ccb9b0401a2bd4bb9c63e87041d4ed25a221c4d0" => :mojave
    sha256 "f5a5b09a5dabb1d434b407f7dd26973368a74e633c71ae49c3646de597af16a1" => :high_sierra
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
