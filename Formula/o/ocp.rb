class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-3.3.1.tar.xz"
  sha256 "924c07f53d45e2bda3e9a4c404ff520dfa49ffed7718ebe6f1d352479bca9ad3"
  license "GPL-2.0-or-later"
  head "https://github.com/mywave82/opencubicplayer.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ocp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "425581f0286925a8dd284435cf64a6f58de1cc70d68925634dfdf26007d74c3b"
    sha256 arm64_sequoia: "174a49cea9b579bb1e5f84590fadeb644b9c1d188158d244b603a9dd97fd18c5"
    sha256 arm64_sonoma:  "7efda933b50036b71ada2ef5dcbbac1fe3d8f71d2af070b2fbeec8611bb9f695"
    sha256 sonoma:        "25ac3da1aa03447608c1b6daa75bd30f9870cb90cf3a81a517495090a8ddacc9"
    sha256 arm64_linux:   "45abf429ba52975346f5956a6d575b70594c98ad02c2a6c34ed97309e8d18695"
    sha256 x86_64_linux:  "b2b5b971a9489b9c584a8996a442754a81159cf772d3c7f683f5060d303df9a9"
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
    url "https://ftpmirror.gnu.org/gnu/unifont/unifont-17.0.04/unifont-17.0.04.tar.gz"
    sha256 "5c52c5d56ef98089ddbca62e68560ceccc57ea88940b9d38cc3c888fe3b59a34"
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
    ENV.deparallelize
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ocp --help 2>&1")

    assert_path_exists testpath/".config/ocp/ocp.ini"
  end
end
