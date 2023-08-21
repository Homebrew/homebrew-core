class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-0.2.106.tar.xz"
  sha256 "bf11d96d4a58bbf9c344eb53cf815fc2097c63a3c2c713f7ffb134073bd84721"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/mywave82/opencubicplayer.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ocp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "98b920bce3a8dd1664102804316a636f1f36a1750d54be98a27d2c208585078f"
    sha256 arm64_monterey: "98bee92ef9e920e5d4e5a16af9efba47eb26bca3bab25bc3b8de8fd57124a526"
    sha256 arm64_big_sur:  "7dfbcf78f996adff1dc4c1dab3f908912b9109e068503361c10546adc397cdb4"
    sha256 ventura:        "43069ef46c4e17de75490c55aa93393420660c2fafbb21dd6af13408601d3d56"
    sha256 monterey:       "bdf0c54732d8169c6f0f2b10ac74eb388234bf41f9a8c7edbceae18e18b0b712"
    sha256 big_sur:        "303b794f8055a4657ecfd8982930b1e7f96cb3f73111d6c5da78dfc9cf6218d8"
    sha256 x86_64_linux:   "7f832d99afc957045e5e577d0d176e3ed4d4af7da5374774cd948df4d5c7345a"
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
