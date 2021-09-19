class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-0.2.90.tar.xz"
  sha256 "e5bb775648c4708c821cb8313932a8fef7dcf1b5035208e56e57779984d60911"
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
