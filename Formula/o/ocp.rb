class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-3.1.1.tar.xz"
  sha256 "33f5c780058eaf8098916b92ee4676c3d6bfce1a2abed39c19cd38154fdccba7"
  license "GPL-2.0-or-later"
  head "https://github.com/mywave82/opencubicplayer.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ocp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "9d4b117fa044ce82848f652307d420edb813b7723d84b9536ea979bfed9e4b8a"
    sha256 arm64_sequoia: "68e8262d387fb1deff4260e9deb6bacaaf45bd1149f71a1a7cc0ed23977d3020"
    sha256 arm64_sonoma:  "1b6feaf01bb81f5f5be245d2aa307b34fe3b61727cfdac11db715f31f0834e64"
    sha256 sonoma:        "2b88edf4e44f22f28562d605ac817adca303afa45b98b39c5685e37fe52b6b23"
    sha256 arm64_linux:   "2c91219f925a014c3502933f5f8d7cf0ff75518b4af8f0062f0932f1143a690f"
    sha256 x86_64_linux:  "969446a2166c8775bed216e8e66f41fa9d68a98c77c5d1881491168d181b05d9"
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
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "sdl2"

  uses_from_macos "bzip2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "libogg"
  end

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
    depends_on "alsa-lib"
  end

  # Fix qoaplay.c:226:5: error: expected expression
  # PR ref: https://github.com/mywave82/opencubicplayer/pull/147
  resource "unifont" do
    url "https://ftpmirror.gnu.org/gnu/unifont/unifont-16.0.02/unifont-16.0.02.tar.gz"
    sha256 "f128ec8763f2264cd1fa069f3195631c0b1365366a689de07b1cb82387aba52d"
  end

  patch do
    url "https://github.com/mywave82/opencubicplayer/commit/9afa7489578258e6f07196a177dcbb7aa014ffe2.patch?full_index=1"
    sha256 "f6dfa4da0815e5dd70ba7463c0ebbfb4e1a1965f9cac70e63e897c3b3dfe1c9c"
  end

  # pin to 16.0.02 to use precompiled fonts
  # https://github.com/mywave82/opencubicplayer/blob/master/mingw/versionsconf.sh#L20

  def install
    # Required for SDL2
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
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocp --help 2>&1")

    assert_path_exists testpath/".config/ocp/ocp.ini"
  end
end
