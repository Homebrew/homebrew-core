class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kx.studio/Applications:Carla"
  license "GPL-2.0-or-later"
  revision 2

  stable do
    url "https://github.com/falkTX/Carla/archive/refs/tags/v2.5.10.tar.gz"
    sha256 "ae2835b12081f7271a6b0b25d34b87d36b022c40370028ca4a10f90fcedfa661"

    # TODO: Use `pyqt` and `qt` from HEAD in 2.6.0
    depends_on "pyqt@5"
    depends_on "qt@5"
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4a0fe53de856ed1a441aee00f23b4840ef3720f28c86b1abd94987af208fe433"
    sha256 cellar: :any, arm64_tahoe:       "7c6944ecc1096faf5c51f9bb9f41a31c3bcfb362e9edea0c1df4528f7996eb1a"
    sha256 cellar: :any, arm64_sequoia:     "01149e89a89f7070948b8dabba8e7fe4892546af144c1cef6dcbd35c3dc09372"
    sha256 cellar: :any, arm64_linux:       "b3dc82d2bc26349ee3d8d6352c17ac00b59e49b19a8f8bfd5616a441e7f767f7"
    sha256 cellar: :any, x86_64_linux:      "b6f49167bc561e17f1245d6fde03358bcd1af24d5261cdfafc4a674da71fbb61"
  end

  head do
    url "https://github.com/falkTX/Carla.git", branch: "main"

    depends_on "pyqt"
    depends_on "qtbase"
    depends_on "qtsvg"
  end

  # Can undeprecate if new release with Qt 6 support is available.
  deprecate! date: "2026-05-19", because: "needs end-of-life Qt 5"
  disable! date: "2027-05-19", because: "needs end-of-life Qt 5"

  depends_on "pkgconf" => :build

  depends_on "fluid-synth"
  depends_on "liblo"
  depends_on "libmagic"
  depends_on "libsndfile"
  depends_on "python@3.15"

  on_linux do
    depends_on "alsa-lib"
    depends_on "freetype"
    depends_on "libx11"
    depends_on "mesa"
    depends_on "pulseaudio"
    depends_on "sdl2-compat"
  end

  def install
    # Workaround for https://github.com/falkTX/Carla/issues/1926
    if build.stable? && OS.mac? && MacOS.version >= :sequoia
      odie "Remove deployment target!" if version >= "2.6"
      ENV["MACOSX_DEPLOYMENT_TARGET"] = "14.0"
    end

    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    inreplace bin/"carla", "PYTHON=$(which python3 2>/dev/null)",
                           "PYTHON=#{python3}"
  end

  test do
    system bin/"carla", "--version"
    system lib/"carla/carla-discovery-native", "internal", ":all"
  end
end
