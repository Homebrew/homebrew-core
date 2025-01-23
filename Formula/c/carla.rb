class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kx.studio/Applications:Carla"
  license "GPL-2.0-or-later"
  revision 1

  stable do
    url "https://github.com/falkTX/Carla/archive/refs/tags/v2.5.9.tar.gz"
    sha256 "226fb5d646b7541b82035080190e7440df1f92372fb798b4ad49289570e5ad81"

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
    sha256 cellar: :any,                 arm64_sonoma:  "ce72afa1076fbddeea49955b0317e5b68f6edf4977820f2a5b70f8901c38b7a7"
    sha256 cellar: :any,                 arm64_ventura: "f9ff117b161827d6cb4baa2dfacbe278f352d2de9f9155065e739dee6bbd07a6"
    sha256 cellar: :any,                 sonoma:        "f1c5e24d843962ef91ea7e4ccf820f829ffe55249fa2ac578cd921d28813ec89"
    sha256 cellar: :any,                 ventura:       "ad08054b961096e4f34b9fb839cdd23d590199c110a8e8b99d1668a2512a86b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f29b248df9d099efa03eb0a3d8ba9276e508e9e72a5ea428b58bc5df4024b176"
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
