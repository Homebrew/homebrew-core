class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kx.studio/Applications:Carla"
  license "GPL-2.0-or-later"

  stable do
    url "https://github.com/falkTX/Carla/archive/refs/tags/v2.5.10.tar.gz"
    sha256 "ae2835b12081f7271a6b0b25d34b87d36b022c40370028ca4a10f90fcedfa661"

    # TODO: Remove in 2.6.0
    depends_on maximum_macos: [:sonoma, :build]

    # TODO: Use `pyqt` and `qt` from HEAD in 2.6.0
    depends_on "pyqt@5"
    depends_on "qt@5"
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "e68c44affb1640960ee3a5523a637b149d5426ca0e40cc8434c1c93c81fbed9b"
    sha256 cellar: :any,                 arm64_ventura: "ecbea509ddf5ef1074d5838e01669a49d48c24baf4ec10d816d894cb39830b7c"
    sha256 cellar: :any,                 sonoma:        "768c0fccfd67bafa8c1e23bbf0531ae88e3f756d4d074079fbad4c7c2b0fe202"
    sha256 cellar: :any,                 ventura:       "8e2274219eda8243736ed5e015cdb5ef62a2add1c1e59280e0ba84738c66abf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a63e9f2d8ecfb2fbee7417dc8b0cb21fd55d64f5d75ae9cdf8d09cd60621c0b"
  end

  head do
    url "https://github.com/falkTX/Carla.git", branch: "main"

    depends_on "pyqt"
    depends_on "qt"
  end

  depends_on "pkgconf" => :build

  depends_on "fluid-synth"
  depends_on "liblo"
  depends_on "libmagic"
  depends_on "libsndfile"
  depends_on "python@3.13"

  on_linux do
    depends_on "alsa-lib"
    depends_on "freetype"
    depends_on "libx11"
    depends_on "mesa"
    depends_on "pulseaudio"
    depends_on "sdl2"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    inreplace bin/"carla", "PYTHON=$(which python3 2>/dev/null)",
                           "PYTHON=#{which("python3.13")}"
  end

  test do
    system bin/"carla", "--version"
    system lib/"carla/carla-discovery-native", "internal", ":all"
  end
end
