class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v2.3.2.tar.gz"
  sha256 "9a4db68246705a52c1476bb81f4a8491c7d128ecc0bb5bde19b954afda1d10c6"
  license "GPL-2.0-or-later"
  head "https://github.com/falkTX/Carla.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "35b8485aa43399484a5ba71be0d8e1960517c88ff788681ce40657009ad42246"
    sha256 cellar: :any, big_sur:       "0dde7e1a7b972ed8121e1fbad3f129f499f8137e1f1e1b686aa6ed86c0974f54"
    sha256 cellar: :any, catalina:      "8f200e6aed534f9be88d37dd4b3c9c75569628c042a434fabe8bcb484c6658b5"
    sha256 cellar: :any, mojave:        "fdfc096ac6766c32b65a655e4fb63cf67810b040505710557317e2a330b56571"
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
