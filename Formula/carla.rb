class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v2.1.1.tar.gz"
  sha256 "8611d6fc579ea55ab205cfb72571eb304da9ef997e7bbae5af5a339ef533d5d9"
  license "GPL-2.0"
  head "https://github.com/falkTX/Carla.git"

  bottle do
    cellar :any
    sha256 "9d9d212871ff2695aa40bd5bca4e412f0e0e02011c800b3517ffd72722095536" => :catalina
    sha256 "ee7af2de53e609f1ccf66149c6935bf638b02fd4c1a3affa0233e14a5553abcd" => :mojave
    sha256 "a7787f941d9bda79e49d47d4fc8ee9e1f5fe8d559c10b93aec0e8d4dfe174d20" => :high_sierra
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
