class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-3.5.0.tar.xz"
  sha256 "914e6ed4ae7702fed569c72bac778ddec377150767c5942aa9aa491f08818eec"
  license "GPL-2.0-or-later"
  head "https://github.com/mywave82/opencubicplayer.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ocp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "7f029bd8a9ea98c6a85482757e87978c7abdca9ac088ceda8b3b46d328815381"
    sha256 arm64_sequoia: "6500942cdd655aedbde7a7d187215bb8e5e0969a3073fe17c277ca6a92d4d0d6"
    sha256 arm64_sonoma:  "5f3bd8bfdec82a2914ee872553fec8f45c705990b8b8d689553ef3f63b1af8d2"
    sha256 sonoma:        "48f7c62aa7f0b6120c1171cd645766ba9180e439f21a88bbf8ecfa7997ed19d2"
    sha256 arm64_linux:   "df9e75706cb63e6c3f0164bc70d671e399d2a3dcc5a0c13093961f230d1a10ba"
    sha256 x86_64_linux:  "bc4e8d0a25baabe06d61d3c16cf3af0ea861341a5181536376648cc17d23abc1"
  end

  depends_on "pkgconf" => :build
  depends_on "xa" => :build

  depends_on "ancient"
  depends_on "cjson"
  depends_on "flac"
  depends_on "freetype"
  depends_on "game-music-emu"
  depends_on "jpeg-turbo"
  depends_on "libdiscid"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "sdl3"

  uses_from_macos "bzip2"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
    depends_on "alsa-lib"
    depends_on "opus"
    depends_on "zlib-ng-compat"
  end

  resource "unifont" do
    url "https://ftpmirror.gnu.org/gnu/unifont/unifont-17.0.05/unifont-17.0.05.tar.gz"
    sha256 "f287cffb26e22723aa36e6684869b0f3ff3bfb822c4b01008bd847911ec1b631"

    livecheck do
      url "https://raw.githubusercontent.com/mywave82/opencubicplayer/refs/heads/master/mingw/versionsconf.sh"
      regex(/^UNIFONT_VERSION="(\d+(?:\.\d+)+)"$/i)
    end
  end

  def install
    # Required for SDL3
    resource("unifont").stage do |r|
      cd "font/precompiled" do
        share.install "unifont-#{r.version}.otf" => "unifont.otf"
        share.install "unifont_csur-#{r.version}.otf" => "unifont_csur.otf"
        share.install "unifont_upper-#{r.version}.otf" => "unifont_upper.otf"
      end
    end

    args = %W[
      --prefix=#{prefix}
      --without-x11
      --without-desktop_file_install
      --without-update-mime-database
      --without-update-desktop-database
      --with-unifontdir-ttf=#{share}
      --with-unifontdir-otf=#{share}
    ]

    # We do not use *std_configure_args here since
    # `--prefix` is the only recognized option we pass
    system "./configure", *args
    ENV.deparallelize
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocp --help 2>&1")

    assert_path_exists testpath/".config/ocp/ocp.ini"
  end
end
