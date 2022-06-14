class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-0.2.99.tar.xz"
  sha256 "d00165e206403b876b18edfc264abc8b6ce3d772be7e784fe4d358e37e57affd"
  license "GPL-2.0-or-later"
  head "https://github.com/mywave82/opencubicplayer.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ocp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "b921004b4dd2cd920438958b4680f1f6a7ec9df6588ef29e02f480633f5b4a6b"
    sha256 arm64_big_sur:  "42c624611c35001ca2b30b68170d732992e339165ddcbd951cba9d96be3c3b58"
    sha256 monterey:       "216dc81701f3216ae552223f3ed09d34ddea880143898c8c1a475ce8b33acd0e"
    sha256 big_sur:        "6ab826f1169833df2eca0cf33f36f88a35d4c12fb9ce8b5d20112ab108740f77"
    sha256 catalina:       "97ff91ef5b48d7ae05a7ada0ba678dd69b825a025dce6c61e04759645d20bbe4"
    sha256 x86_64_linux:   "125015cdc649ee1c0c3f1b770ca8cbc4a93ba8123a824687070196aea61da5e6"
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
