class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-3.1.3.tar.xz"
  sha256 "4e8579b18d47ba2f4c667f577aa3286f6f8c4ea0b6192ff743f0f21678e60afd"
  license "GPL-2.0-or-later"
  head "https://github.com/mywave82/opencubicplayer.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ocp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "2d23e0b0530d6bafafef1259a1fff14c2916dd79a870bb7b27756624d3b35350"
    sha256 arm64_sequoia: "f01b64978bdb81b847488dc78660843931c48b2ad6b1aefe6eb16c8b1847cf63"
    sha256 arm64_sonoma:  "25b6f1b7d06c8bac738883be72159dbc678d6cf9c7f5dc32e97769f071dc77ad"
    sha256 sonoma:        "92b55ed46999d3426fde9c7c8760875ad5122fee38b5701f756f1fe19aea2a0c"
    sha256 arm64_linux:   "9ab4e98fe3824a0e1368452702963e872da9d9e13a85237a5a36b519bc362f71"
    sha256 x86_64_linux:  "935e516dcc588bb438eee0531c18242d49a4d3b532ff6579c3302b5de37f39d5"
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

  on_macos do
    depends_on "libogg"
  end

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
    depends_on "alsa-lib"
    depends_on "zlib-ng-compat"
  end

  # Fix qoaplay.c:226:5: error: expected expression
  # PR ref: https://github.com/mywave82/opencubicplayer/pull/147
  # pin to 16.0.02 to use precompiled fonts
  # https://github.com/mywave82/opencubicplayer/blob/master/mingw/versionsconf.sh#L20
  resource "unifont" do
    url "https://ftpmirror.gnu.org/gnu/unifont/unifont-16.0.02/unifont-16.0.02.tar.gz"
    sha256 "f128ec8763f2264cd1fa069f3195631c0b1365366a689de07b1cb82387aba52d"
  end

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
