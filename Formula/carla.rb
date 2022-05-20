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
    sha256 cellar: :any,                 arm64_big_sur: "1640e2ca5e75448074727b3bc28f01057676877712fbf4b3cfdbeac9a6a6d2e8"
    sha256 cellar: :any,                 big_sur:       "2f38b8ec4582c16d3c19b61c10dd1bbb6668bef05284edda5c18e6defbb4a07b"
    sha256 cellar: :any,                 catalina:      "ef913d5eaaba882d6e0911524755c4fc3684be537bb224267dbd8a8c2f1d3efa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "348ca755162c5d4e1ae23c2e6afed1cc81fc17b24ab80335a2cf6f3c442f7b0d"
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
