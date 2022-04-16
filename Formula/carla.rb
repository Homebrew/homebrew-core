class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v2.4.3.tar.gz"
  sha256 "0092926e5167f3a5eb592f0055e5491803354ae42947e706db0dc548d9e786d3"
  license "GPL-2.0-or-later"
  head "https://github.com/falkTX/Carla.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "47675f00c8b4a6651eb405321709115d71886fe0b9b13badf82cbd42bba34825"
    sha256 cellar: :any,                 big_sur:       "0303540b446d18d094cd6672687fbf80f434baa5fd92dc0d98c7fa30c672d184"
    sha256 cellar: :any,                 catalina:      "e81b8c253c51edf12ddef8b6ad8f2e4409102d98b9ce3cf5ea12a8f3f965eb21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f83cc88afa3b583ee452b733cd4de4664c0fd7578ee24ab89d7cea314bfb7eb0"
  end

  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "liblo"
  depends_on "libmagic"
  depends_on "pyqt@5"
  depends_on "python@3.9"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

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
