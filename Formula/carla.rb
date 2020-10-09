class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v2.2.0.tar.gz"
  sha256 "4bf08511257db88979eccc002f10c153ff2a14f5143291c2be39cadd69ce10e1"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/falkTX/Carla.git"

  livecheck do
    url "https://github.com/falkTX/Carla/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "1b3bc683f5671334c8d5e2ca01dd304d122cee9d95f3cc4cc4f41c60076d9af9" => :catalina
    sha256 "7554f8791409b5bf2b1b1cae0ee87d32572937a8f73e62065cbcd4811bd39575" => :mojave
    sha256 "89c00822dd9365366d58cdff17ce720f99daec9ca11faa0507bf346e42c9bf93" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "liblo"
  depends_on "libmagic"
  depends_on "pyqt"
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
