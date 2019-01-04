class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v1.9.12.tar.gz"
  sha256 "f4711cb857ea5c409b4602ab2254956d4f24311ed292048f9013163c953e0f30"
  head "https://github.com/falkTX/Carla.git"

  bottle do
    sha256 "b58bb67d7296dde12f72e1acd0b577974629ca1181b8598cddd8dc1febb38706" => :mojave
    sha256 "5894be46ea05fb86e31c401cbc05a789bcd4d9007bd19ac10bb6eb4f41bb49b2" => :high_sierra
    sha256 "1f80475093e48c1fdd3f4c3c21b3e797f25064f6c501d279e6108ef3962fe471" => :sierra
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
