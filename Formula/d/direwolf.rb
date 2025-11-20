class Direwolf < Formula
  desc "Software \"soundcard\" AX.25 packet modem/TNC and APRS encoder/decoder"
  homepage "https://github.com/wb2osz/direwolf"
  url "https://github.com/wb2osz/direwolf/archive/refs/tags/1.8.1.tar.gz"
  sha256 "89d5f7992ae1e74d8cf26ec6479dde74d1f480bde950043756e875a689d065d7"
  license all_of: [
    "GPL-2.0-or-later",
    "ISC", # external/misc/{strlcpy.c,strlcat.c} (Linux)
    :cannot_represent, # external/geotranz, see https://github.com/externpro/geotranz/blob/v2.4.2/readme.txt
  ]
  head "https://github.com/wb2osz/direwolf.git", branch: "master"

  bottle do
    sha256                               arm64_tahoe:   "9008dc9817a0f1347080c4be96835c8fb3027fa6debf6bb0d18fdbab946e281c"
    sha256                               arm64_sequoia: "5b1d6e6e848c4efa27f876d85f3054a9f07b246ecfff29a63ee909807cc5e897"
    sha256                               arm64_sonoma:  "713aa3d8ba23eee64dc23350d532ec49cc3dfecea2817fa9b5285259b95901e0"
    sha256                               sonoma:        "d36dc36d74edb5638a744bd3eb83026c2a938272632b58f871aaaff2014fbaf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1f3591c8db7d3a803abdce7d524174796929a8db3f3d8e1a9319138651d2d15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52d4e83a054f979e47a3eb26ccd9560187f926ba6328c9924bf220971fa33282"
  end

  depends_on "cmake" => :build
  depends_on "gpsd"
  depends_on "hamlib"

  on_macos do
    depends_on "hidapi"
    depends_on "portaudio"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "systemd"
  end

  def install
    inreplace "src/symbols.c", "/opt/local/share", share
    inreplace "conf/CMakeLists.txt", " /usr/lib/udev/rules.d", " #{lib}/udev/rules.d"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "--build", "build", "--target", "install-conf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/direwolf -u")

    touch testpath/"direwolf.conf"
    assert_match "Pointless to continue without audio device.", shell_output("#{bin}/direwolf brew", 1)
  end
end
