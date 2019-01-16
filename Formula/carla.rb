class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v1.9.13.tar.gz"
  sha256 "cc6639dd23b22279f8ab1ae9b51e71d5480b86112c475110daa68cf68fb8cf63"
  revision 1
  head "https://github.com/falkTX/Carla.git"

  bottle do
    cellar :any
    sha256 "b8bf3cb55de8af9005d8b982df36f55698107b2ff5022909003793a3421d9633" => :mojave
    sha256 "a5350b1b6d4c6e560ee71f8621f80e4550e54c3cb9f59915a55d5767a0706860" => :high_sierra
    sha256 "30494098b93d0b5c6497d2c4a677096bea711a8c05dfd2d8c779c7a92a088b99" => :sierra
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
