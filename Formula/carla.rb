class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v2.2.0.tar.gz"
  sha256 "4bf08511257db88979eccc002f10c153ff2a14f5143291c2be39cadd69ce10e1"
  license "GPL-2.0-or-later"
  revision 3
  head "https://github.com/falkTX/Carla.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, big_sur:  "ac073b4a20473ceedd7fd76fb0e7a07903447acc6f70026c83b123006c756109"
    sha256 cellar: :any, catalina: "597c71ba1dd3bbdd9de436863dd030db4fbcf12a73029c6eb8d5bffe6901eee0"
    sha256 cellar: :any, mojave:   "a8b52e79827ed3132f5dfce5b5c6631d72bd5ea0309b6b8fa6d2ec77d67fb7c7"
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
