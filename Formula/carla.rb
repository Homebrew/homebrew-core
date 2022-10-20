class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v2.5.2.tar.gz"
  sha256 "e93c5d169538c991e1598c7de34a80f2e53af3cd063bb672fa020ba8e7dae140"
  license "GPL-2.0-or-later"
  head "https://github.com/falkTX/Carla.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9efe2e3573a58e18f7382854f260928ba7625cb9f530df5602648cd0a8cb847f"
    sha256 cellar: :any,                 arm64_big_sur:  "ac156cbb38fd2b0bf26d7985253694ccba290111865ec3541e176ca9024a2ea7"
    sha256 cellar: :any,                 monterey:       "11f18c56494fec6baf11ac6750b1d082e125637b69bdaf1b4c13aacf8ac991df"
    sha256 cellar: :any,                 big_sur:        "e358b46e69f3cfb2270a029c65561b228e87876b5c7c1fe5d86a193219619143"
    sha256 cellar: :any,                 catalina:       "e713bfef7d6515848366229e3e798894ce7a5bbc062d8980a7815b12c2d675dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97b01b6e7b785876a494ce3b43a2b3b124d38b1223138897db651496277e4832"
  end

  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "liblo"
  depends_on "libmagic"
  depends_on "pyqt@5"
  depends_on "python@3.10"

  fails_with gcc: "5"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    inreplace bin/"carla", "PYTHON=$(which python3 2>/dev/null)",
                           "PYTHON=#{Formula["python@3.10"].opt_bin}/python3.10"
  end

  test do
    system bin/"carla", "--version"
    system lib/"carla/carla-discovery-native", "internal", ":all"
  end
end
