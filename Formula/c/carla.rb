class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v2.5.7.tar.gz"
  sha256 "e530fb216d96788808f20bd7aaac8afdd386d84954ae610324d7ba71ffbc4277"
  license "GPL-2.0-or-later"
  head "https://github.com/falkTX/Carla.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "896ca3dcf1b37351bfc1a15b2d7954af88ed7b35fa31d7353513e596a6d4cd7e"
    sha256 cellar: :any,                 arm64_ventura:  "bd481c1b38dd6258d32e8ce8baf47d0f78d2d2c218d7a4a7be20ff2c13c4425a"
    sha256 cellar: :any,                 arm64_monterey: "6d34406f719286500d8c4a3a6111a39082c70faf60c560f1f051687ef30b80a8"
    sha256 cellar: :any,                 sonoma:         "69c166a47f9080b79197832851f36dcca8f60b2249b8e6439c57015fda995dc1"
    sha256 cellar: :any,                 ventura:        "bf97f69ad97b5e098e2385f9330d68e56e42df62c760f1e09a7822aacb8c3077"
    sha256 cellar: :any,                 monterey:       "7809ab93127dab0523581aab8ded5a1a7c0a24406d6bb22634e55c6997cd6e6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03acbd37705d2f9845ebc6f95393b256307e47d7f80ee35a95d3b5e049aeae44"
  end

  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "liblo"
  depends_on "libmagic"
  depends_on "pyqt@5"
  depends_on "python@3.11"

  fails_with gcc: "5"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    inreplace bin/"carla", "PYTHON=$(which python3 2>/dev/null)",
                           "PYTHON=#{Formula["python@3.11"].opt_bin}/python3.11"
  end

  test do
    system bin/"carla", "--version"
    system lib/"carla/carla-discovery-native", "internal", ":all"
  end
end
