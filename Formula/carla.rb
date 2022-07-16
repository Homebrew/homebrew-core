class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v2.5.0.tar.gz"
  sha256 "f1077caa97b52fedc0d567f7f0e561b466031b5b34b760cd68efe836e19d408d"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/falkTX/Carla.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "91b9647985a6e614ce14330ee49be79772ea2909ce46ff5da23f193ffa363a62"
    sha256 cellar: :any,                 arm64_big_sur:  "325759e3d62a0b84f73e0fbe8dc6e6b78866f1043e80be95aec406769fe25461"
    sha256 cellar: :any,                 monterey:       "52a7165ecb66b48eea1e61e4334733d053f1a9ff62192dc55a5bb391a2606c38"
    sha256 cellar: :any,                 big_sur:        "523a82556c29048c22ed73bfded1410340e1ed46a9972c0f235b3ce457a8afcf"
    sha256 cellar: :any,                 catalina:       "dcf786ecab3962d2cd2d9496e314968f1f7903c1f76ce6692e14cee46d026cfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccc4816065c21f468728fe81a2989967caab6f365e3547f75175728746922487"
  end

  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "liblo"
  depends_on "libmagic"
  depends_on "pyqt@5"
  depends_on "python@3.10"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    inreplace bin/"carla", "PYTHON=$(which python3 2>/dev/null)",
                           "PYTHON=#{Formula["python@3.10"].opt_bin}/python3"
  end

  test do
    system bin/"carla", "--version"
    system lib/"carla/carla-discovery-native", "internal", ":all"
  end
end
