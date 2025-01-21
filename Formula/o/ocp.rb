class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-3.0.1.tar.xz"
  sha256 "60a03d73883ea9c5dd94253907fc2002aa229e0fc41febb17d7baa341b228db1"
  license "GPL-2.0-or-later"
  head "https://github.com/mywave82/opencubicplayer.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ocp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "4d4d287a60ac8edc317dffcb07feb6c23bf1cb54007ba45dfdbd3f4470b32059"
    sha256 arm64_sonoma:  "962b118d6aa52c978601e4e883cb5bcc126c71ea7f79da884fff7586f4cd36f4"
    sha256 arm64_ventura: "8047661b61d3c6108da0f3afa9a1f378c514e6dae83aecdbc39770bddd2533c7"
    sha256 sonoma:        "29f04bc146add83b8a79e4e429de670ca2b3b05aedf5ace9153ff01c9f9d7a8e"
    sha256 ventura:       "c490c649231ce92725e67f5ca97acc59649f157403f89fb7e3e721d0efc64226"
    sha256 x86_64_linux:  "82469d6356888ba79497060ddf9c1cc7223a84e555aacf9116c7724b8af03feb"
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

  # pin to 15.0.6 to use precompiled fonts
  resource "unifont" do
    url "https://ftp.gnu.org/gnu/unifont/unifont-15.0.06/unifont-15.0.06.tar.gz"
    sha256 "36668eb1326d22e1466b94b3929beeafd10b9838bf3d41f4e5e3b52406ae69f1"
  end

  def install
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
