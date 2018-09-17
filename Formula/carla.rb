class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v1.9.11.tar.gz"
  sha256 "b79e13f204309c6cafdb51a753314732898a5c37b502e3f922d283a1b94bfea5"

  bottle do
    sha256 "ddb9025f85cf9ca17196e925c7a7740a11de4cb1eda8a5a023062b7afdd40250" => :mojave
    sha256 "45ba611e4561f9517bee5f6ea23205513918d17b842e455e14ead3c94537e677" => :high_sierra
    sha256 "8bb3273617fc9022664f1b00a3e122ca6d815c293266fc630f8698fdf1e1db3f" => :sierra
    sha256 "4106e1d3fd40b994df4303f5b70a189258305ee5b82aa2946d47bda8bfd91be4" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "liblo"
  depends_on "libmagic"
  depends_on "pyqt"
  depends_on "python"

  def install
    args = []
    if ENV.compiler == :clang && MacOS.version <= :mountain_lion
      args << "MACOS_OLD=true"
    end

    system "make", *args
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"carla", "--version"
    system lib/"carla/carla-discovery-native", "internal", ":all"
  end
end
