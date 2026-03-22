class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-3.2.0.tar.xz"
  sha256 "c2f6fe7edc89a2625ae22f88628f9bc294621cb49efaacb1cd42a4005920098a"
  license "GPL-2.0-or-later"
  head "https://github.com/mywave82/opencubicplayer.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ocp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "414fcd1dcc5e1a3fc03bcb53c0f3eec4044fd87b8df8bb1273f34540d73e9637"
    sha256 arm64_sequoia: "40b1ae9d29fcf9bcb03a876451cbc1d06b8157aab4827b5faae29f8672f2b587"
    sha256 arm64_sonoma:  "29a2049d72156bee3b6277264f48cb9491359caaa5cf1145496adf3ef035905f"
    sha256 sonoma:        "17c7965a78768c612d9b836dc36904b9fc4b1985ceea69ae4945648a1429e365"
    sha256 arm64_linux:   "94ab3e17dd820d8408243bed7b41d25a27ea6099139c19dfdbcb7b1c40d41fd6"
    sha256 x86_64_linux:  "7f2e230299f3db23ac72465114fe0f74eb0693227c18a6ef73bcaeaf9c6f93a7"
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
  depends_on "sdl3"

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

  # https://github.com/mywave82/opencubicplayer/blob/master/mingw/versionsconf.sh#L20
  resource "unifont" do
    url "https://ftpmirror.gnu.org/gnu/unifont/unifont-17.0.03/unifont-17.0.03.tar.gz"
    sha256 "9a26aa9adfa8eb1f91b0cd9b83e7f95ea9e14c6e85be71aa3ab0df5cb4e69c35"
  end

  # Fix clang parse failure for declarations after labels, upstream PR ref, https://github.com/mywave82/opencubicplayer/pull/168
  patch do
    url "https://github.com/mywave82/opencubicplayer/commit/af5e034a317abbf5e352fd371308fae47d0d1e58.patch?full_index=1"
    sha256 "1c0d58d4097e1d439718b0eddfdf46c60f53721f3b66c9bf180b566de3f342f0"
  end

  def install
    # Required for SDL3
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
