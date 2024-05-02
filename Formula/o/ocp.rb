class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-0.2.109.tar.xz"
  sha256 "aa043503bd1dfd1433fabe0d5f4bb85bcadc3bae8cc19630a77c89182bce8d90"
  license "GPL-2.0-or-later"
  head "https://github.com/mywave82/opencubicplayer.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ocp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "462d8e35f07308e170caa48842075baa49a1cc8f0f7ffb2d14929cf7e9d63e49"
    sha256 arm64_ventura:  "8680caad7650448489b181ef095e82a20f2a3757b6ed9e546f045ea1eab3b12b"
    sha256 arm64_monterey: "c522fdc20022948049c46fe8ff99f0d3e6702049c1fa65ed4dd598a3206aab27"
    sha256 sonoma:         "940a928439f2840880e05cee094e86a9509f5be3cbbb3bf119c3e75178993cc3"
    sha256 ventura:        "75906ae975ffe405f47d8a06f2d57286022a44c7bd18d734173d4e0e7eee80ae"
    sha256 monterey:       "26d1ae3d2c0bfb0e267994a1be776301ebe10672c1ba514c47af7b6ef96c2102"
    sha256 x86_64_linux:   "4cd81c537874b42e0de929447ecc9fe813030cce6a3b1296caf32309233239bb"
  end

  depends_on "pkg-config" => :build
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

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
  end

  # pin to 15.0.6 to use precompiled fonts
  resource "unifont" do
    url "https://ftp.gnu.org/gnu/unifont/unifont-15.0.06/unifont-15.0.06.tar.gz"
    sha256 "36668eb1326d22e1466b94b3929beeafd10b9838bf3d41f4e5e3b52406ae69f1"
  end

  def install
    ENV.deparallelize

    # Required for SDL2
    resource("unifont").stage do |r|
      cd "font/precompiled" do
        share.install "unifont-#{r.version}.ttf" => "unifont.ttf"
        share.install "unifont_csur-#{r.version}.ttf" => "unifont_csur.ttf"
        share.install "unifont_upper-#{r.version}.ttf" => "unifont_upper.ttf"
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

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ocp", "--help"
  end
end
