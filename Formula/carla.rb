class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v2.4.0.tar.gz"
  sha256 "960a1288ef82543df27e0896a174dae8ff68d24594b6efe0b952105797162c0e"
  license "GPL-2.0-or-later"
  head "https://github.com/falkTX/Carla.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "344cf64400d6b4bfdaa723e2299621e6542999f6fe59414bc33b70cb906a81d2"
    sha256 cellar: :any, big_sur:       "ab12311d3a89d82ebada3c72932b8dbf173c9c140d6ededd9ce4321705663d82"
    sha256 cellar: :any, catalina:      "35fcbec0d1ed5c963238803dfccaac533601493ed32ad99d10e8233829c7a767"
    sha256 cellar: :any, mojave:        "6663e3897523b2b79d5f70d2f911602a3983559ff2787e45dc469f14cae1388d"
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
