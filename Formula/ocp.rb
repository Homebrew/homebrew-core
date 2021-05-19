class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-0.2.90.tar.xz"
  sha256 "e5bb775648c4708c821cb8313932a8fef7dcf1b5035208e56e57779984d60911"
  license "GPL-2.0-or-later"
  head "https://github.com/mywave82/opencubicplayer.git"

  livecheck do
    url :homepage
    regex(/href=.*?ocp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "a26bc2cdded0a238a1fbe376be1c7ccd755b28352bc918b05fcb726b64347f3a"
    sha256 big_sur:       "3aa881d279e6b72656bd08b9394b3ca5eeddc78b91529735ebbc59a3fad91c33"
    sha256 catalina:      "ea5ae27e76002683c28eefae03de9d5867d88eb8b6491e4d28b736937fc871a5"
    sha256 mojave:        "f7ea663318cf0f5a221b53bbc080094fe5931760d3cde229f44dc95f3aa8eba9"
  end

  depends_on "pkg-config" => :build
  depends_on "xa" => :build
  depends_on "flac"
  depends_on "freetype"
  depends_on "jpeg-turbo"
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

  resource "unifont" do
    url "https://ftp.gnu.org/gnu/unifont/unifont-13.0.06/unifont-13.0.06.tar.gz"
    sha256 "68def7a46df44241c7bf62de7ce0444e8ee9782f159c4b7553da9cfdc00be925"
  end

  def install
    ENV.deparallelize

    # Required for SDL2
    resource("unifont").stage do
      cd "font/precompiled" do
        share.install "unifont-13.0.06.ttf" => "unifont.ttf"
        share.install "unifont_csur-13.0.06.ttf" => "unifont_csur.ttf"
        share.install "unifont_upper-13.0.06.ttf" => "unifont_upper.ttf"
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
