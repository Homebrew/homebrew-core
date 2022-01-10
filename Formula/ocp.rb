class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-0.2.91.tar.xz"
  sha256 "bac7394de35a198e4e97c5236fb8b4992850ccf7fffbb8cb49e02b9b5a0f7cf5"
  license "GPL-2.0-or-later"
  head "https://github.com/mywave82/opencubicplayer.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ocp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "4e39e14e21a39d835a98ac386b88cbc01d1eb7c45cf590a982a38b48691c6da2"
    sha256 big_sur:       "b1a86ede27aa902aa73ae8d304c1b48a6fd51f4c40597a6d7c96c8f6f9b25195"
    sha256 catalina:      "796c250a21ccae79be58dd293a9a46544e0dcdbbdce2e6eb75f168213ff4fe60"
    sha256 mojave:        "c1d02d5c7f9c8e0b4de6ddecec03dffc9347b0b52d4597fd9e480c94ac63630f"
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
    url "https://ftp.gnu.org/gnu/unifont/unifont-14.0.01/unifont-14.0.01.tar.gz"
    sha256 "7ad1daeecc466685cdb3c60bdd57d6f3553131f076c1a18ab2f95e2020b26d72"
  end

  def install
    ENV.deparallelize

    # Required for SDL2
    resource("unifont").stage do
      cd "font/precompiled" do
        share.install "unifont-14.0.01.ttf" => "unifont.ttf"
        share.install "unifont_csur-14.0.01.ttf" => "unifont_csur.ttf"
        share.install "unifont_upper-14.0.01.ttf" => "unifont_upper.ttf"
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
