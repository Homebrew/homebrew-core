class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-0.2.95.tar.xz"
  sha256 "94bffa3c7e7c1633a95a914c2d5b6fcf8d133e944f8e3455b5742d70e37b0231"
  license "GPL-2.0-or-later"
  head "https://github.com/mywave82/opencubicplayer.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ocp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "4cc24afa1801076f49fe41a24de65ba812aaf1bba577088c92f7a6424ae44658"
    sha256 arm64_big_sur:  "7d8d2c2ce8478701d8297cce25daf82fd4fd07d41f57dbe47907ddfb51b57d3b"
    sha256 monterey:       "0dac7fa3bbd1108fd6b6d4c3f9203c38ac9a221c9b88cb0e0bde1f7281d6ff62"
    sha256 big_sur:        "143894d4658f2c7fad5852d1c3c4d9b72c136c1172eebd3991d9cc8a8b0582d3"
    sha256 catalina:       "4e1ed4098098c347f44d9f6b64fd4ae8686231a2903967e228a9f4910e3f6853"
    sha256 x86_64_linux:   "c59e438b69ab327ea8b46d4b0c5493beaab5e07f52e46d7449eb63614bc3d20a"
  end

  depends_on "pkg-config" => :build
  depends_on "xa" => :build
  depends_on "cjson"
  depends_on "flac"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libdiscid"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"

  if MacOS.version < :catalina
    depends_on "sdl"
  else
    depends_on "sdl2"
  end

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
  end

  resource "unifont" do
    url "https://ftp.gnu.org/gnu/unifont/unifont-14.0.02/unifont-14.0.02.tar.gz"
    sha256 "401bb9c3741372c1316fec87c392887037e9e828fae64fd7bee2775bbe4545f7"
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
      --with-unifontdir=#{share}
    ]

    args << if MacOS.version < :catalina
      "--without-sdl2"
    else
      "--without-sdl"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ocp", "--help"
  end
end
