class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-0.2.103.tar.xz"
  sha256 "b526d27e983e292453d2ccc36946ee3efd3ba33ee0489507a9815f2f05a23b5e"
  license "GPL-2.0-or-later"
  head "https://github.com/mywave82/opencubicplayer.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ocp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "375697a232e9e7af0d591cb2500f0db57eeee8beff8d5c3b46866eb11170fd11"
    sha256 arm64_monterey: "84a32d1a58c50e85ac574e76d347a24a236f5b9b3db87b0634571d6a6820abbb"
    sha256 arm64_big_sur:  "8033ad3b730d5515d54ffcecbb9afd16b865f9974a2ed5606b6d198f6a6d45cf"
    sha256 ventura:        "df97a3b327f85bb490d4cdcec936ee8df0af81235747772dee0946c8c69661e0"
    sha256 monterey:       "06e97a71d4c7912e05563149d1c8cde0439d82ca66a8bbc179c547608978e0f1"
    sha256 big_sur:        "37f36cee885d4047e6104adef547cec8b4700d4be43a9e1865aa8a9aa302cc20"
    sha256 x86_64_linux:   "b5041caf3e320060cc032589c11cb63641c400defc05318b18e732d07fea5e30"
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
