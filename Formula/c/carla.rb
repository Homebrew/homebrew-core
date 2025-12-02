class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kx.studio/Applications:Carla"
  license "GPL-2.0-or-later"
  revision 1

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
    sha256 cellar: :any,                 arm64_tahoe:   "e262b34d4e21d5ca0d5abbd27a19ee022eb195a52c0622c814456e1cd95f1454"
    sha256 cellar: :any,                 arm64_sequoia: "67daad4cbe5241d8c83ed16f26f4de4f4ca40c737895428da7c0924fb3bf6a6c"
    sha256 cellar: :any,                 arm64_sonoma:  "3757c8d6ac0389d6181b9dfb7ab66d48dc426bfe310715756f4c6b2fd408f11a"
    sha256 cellar: :any,                 sonoma:        "cd9c3cfbd45c97b0a82fc238c0dc96a4ba41f523459eddb07d8541319482c8b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b951b632b5eed8b2600195552a1dea945cc16cc79d8a6a1059fec105f1e0742e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ed922b11d7bb6755b0745ad5a51fb581909d653263830b41639299272ae3ff3"
  end

  head do
    url "https://github.com/falkTX/Carla.git", branch: "main"

    depends_on "pyqt"
    depends_on "qtbase"
    depends_on "qtsvg"
  end

  depends_on "pkgconf" => :build

  depends_on "fluid-synth"
  depends_on "liblo"
  depends_on "libmagic"
  depends_on "libsndfile"
  depends_on "python@3.14"

  on_linux do
    depends_on "alsa-lib"
    depends_on "freetype"
    depends_on "libx11"
    depends_on "mesa"
    depends_on "pulseaudio"
    depends_on "sdl2"
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
                           "PYTHON=#{which("python3.14")}"
  end

  test do
    system bin/"carla", "--version"
    system lib/"carla/carla-discovery-native", "internal", ":all"
  end
end
