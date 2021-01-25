class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-0.2.2.tar.xz"
  sha256 "afd07a6ae2af4733eb06e516cb607276ee084d1d30aa1cf0c3fd6e62f1d3a144"
  license "GPL-2.0-or-later"
  head "https://github.com/mywave82/opencubicplayer.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "3aa881d279e6b72656bd08b9394b3ca5eeddc78b91529735ebbc59a3fad91c33" => :big_sur
    sha256 "a26bc2cdded0a238a1fbe376be1c7ccd755b28352bc918b05fcb726b64347f3a" => :arm64_big_sur
    sha256 "ea5ae27e76002683c28eefae03de9d5867d88eb8b6491e4d28b736937fc871a5" => :catalina
    sha256 "f7ea663318cf0f5a221b53bbc080094fe5931760d3cde229f44dc95f3aa8eba9" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "xa" => :build
  depends_on "flac"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --without-x11
      --without-sdl
      --without-sdl2
      --without-desktop_file_install
    ]

    # Workaround for bad compiler version check: https://github.com/mywave82/opencubicplayer/issues/30
    inreplace "configure",
              "2.95.[2-9]|2.95.[2-9][-].*|3.[0-9]|3.[0-9].[0-9]|3.[0-9]|3.[0-9].[0-9]-*|4.*|5.*|6.*|7*|8*|9*|10*",
              "[1-9]*"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ocp", "--help"
  end
end
