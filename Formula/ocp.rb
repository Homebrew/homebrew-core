class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-0.2.99.tar.xz"
  sha256 "d00165e206403b876b18edfc264abc8b6ce3d772be7e784fe4d358e37e57affd"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/mywave82/opencubicplayer.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ocp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "e195a02f6dab9fc8e4b30e31547034b13039fba747661a4766687140e7eb7b68"
    sha256 arm64_big_sur:  "75911d550ddb535f734d993be08f7dabed15c104ee5baddac6f8372ef2e20c9a"
    sha256 monterey:       "2893b8000462f2f34f6a7a55f8e1108c6acfc4dcf722a72851501095cb87e024"
    sha256 big_sur:        "1779607df1ff5012c075b874e1ff5326d1555a696f136c1d24e81f01921e2dc9"
    sha256 catalina:       "bb3ee3bacf36067cf20a370b9d971390111a3ffce3097a914c2f208a8d147a69"
    sha256 x86_64_linux:   "85106bb45b1a796245a230d29bec2bc482de065720753196548381f10c7a6c19"
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

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_mojave :or_older do
    depends_on "sdl12-compat"
  end

  on_system :linux, macos: :catalina_or_newer do
    depends_on "sdl2"
  end

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

    args << if OS.mac? && MacOS.version < :catalina
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
