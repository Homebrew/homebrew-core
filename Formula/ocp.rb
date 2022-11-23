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
    sha256 arm64_ventura:  "cc1056ad1f983099c556ad8bde36f860abe50fcd5bcd541ab6e4a782b0a5bf32"
    sha256 arm64_monterey: "9edc28eaa5cf8ed6e167f210507a6a0c3ef4c7d575daf0b4bc92aa07d0164486"
    sha256 arm64_big_sur:  "82e19216f43ce9d8987fa9d12060dc73a6466b47002406809f3f7576ca618e8e"
    sha256 ventura:        "c5c00769fa6624fbdf1530d6feb74e1abc9e513ba2c7f86aa4d89d5c748c053f"
    sha256 monterey:       "ecab66f3af0eafc0d7b07d11c08ef876ef6e4865fe78ca599cda2dc20cfa8288"
    sha256 big_sur:        "9310045304a8d3c2147c4ed62771fe8b6991f93de5f83d99ea7af7c1d3081cde"
    sha256 catalina:       "3b6c634729414ba56a28bee50525a1571218066a8ce3814db3d67006527891d4"
    sha256 x86_64_linux:   "c1e03126316630cba2f978965a17d41f726b9f8105ab74fea5425a185f33efb3"
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
