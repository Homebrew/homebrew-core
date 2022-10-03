class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  url "https://github.com/falkTX/Carla/archive/v2.5.1.tar.gz"
  sha256 "c47eea999b2880bde035fbc30d7b42b49234a81327127048a56967ec884dfdba"
  license "GPL-2.0-or-later"
  head "https://github.com/falkTX/Carla.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "84ff0ddeb198c505271993cce92e05d6fd1c1a4bfdfbf1701121464715dc2601"
    sha256 cellar: :any,                 arm64_big_sur:  "d809ab0142ec1c144b64ed44f730241dc9909fb00b71dcab2f8b8c1a0775f38c"
    sha256 cellar: :any,                 monterey:       "16458248b4067b67d0ea33acf71e6f58af58c79f53cde2d40efbf2cb0aa56d63"
    sha256 cellar: :any,                 big_sur:        "bb03c8a8b000baabd032e8f888a50b4d0a049449cbc281e809334e0693c23391"
    sha256 cellar: :any,                 catalina:       "82026c919f5be0c50f0d6e95507e0f6bae64100d86c8ef526ed2a9c458f72a1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac3e0ecaaaebdcbd00de563e9a84eec272f12b9f9b5101ece647ca5ee5b80f5e"
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
