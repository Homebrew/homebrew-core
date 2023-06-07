class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-0.2.105.tar.xz"
  sha256 "1a87b3c572679fb681a25bf158bdc1cc078018d0507965e1557610c17fcccfc5"
  license "GPL-2.0-or-later"
  head "https://github.com/mywave82/opencubicplayer.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ocp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "3690f47824577f3df596994371ce56932d68a875a6d2d4e0d9e19e442d9624d4"
    sha256 arm64_monterey: "1ba0669652567aecd14feb6c517ec77b5b0ee5964de54e4e69ad78030efb9296"
    sha256 arm64_big_sur:  "bbcbda1ecb8bad6dad0db51abfc171e82b558223a20ec67cf9b948259c8d0973"
    sha256 ventura:        "02825ed5010ac2760131fe2bb0737c6e14d11a9066039b36ccf9687e2e1da77a"
    sha256 monterey:       "eb34a21ed728ffe4598edc3664094045fe4ad11ce29beb797e17776b9857fdc1"
    sha256 big_sur:        "614c28d5a6ab0df1385e37168354df743aeb68b1fad5c8672129be20ec277056"
    sha256 x86_64_linux:   "8d9e1a49c80862bf0940bdddf2302b6646cd5d936a02d1683f293a9143683c2d"
  end

  depends_on "pkg-config" => :build
  depends_on "xa" => :build
  depends_on "ancient"
  depends_on "cjson"
  depends_on "flac"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libdiscid"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "sdl2"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
  end

  resource "unifont" do
    url "https://ftp.gnu.org/gnu/unifont/unifont-15.0.01/unifont-15.0.01.tar.gz"
    sha256 "7d11a924bf3c63ea7fdf2da2b96d6d4986435bedfd1e6816c8ac2e6db47634d5"
  end

  # patch for clockid_t redefinition issue
  patch do
    url "https://github.com/mywave82/opencubicplayer/commit/6ad481d04cf34f29755b12aac9e9e3c046cfe764.patch?full_index=1"
    sha256 "85943335fe93e577ef42c427f32b9a3759ec52beed86930e289205b2f5a30d1a"
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
      --without-update-mime-database
      --without-update-desktop-database
      --with-unifontdir-ttf=#{share}
      --with-unifontdir-otf=#{share}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ocp", "--help"
  end
end
