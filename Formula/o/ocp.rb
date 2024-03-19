class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  license "GPL-2.0-or-later"
  head "https://github.com/mywave82/opencubicplayer.git", branch: "master"

  stable do
    url "https://stian.cubic.org/ocp/ocp-0.2.107.tar.xz"
    sha256 "7627e4fe3acf7ffd7108ac2a6bf53e8a28de7a220c054338c8642c4e37d94626"

    # Backport fix for label in front of variable. Remove in the next release.
    patch do
      url "https://github.com/mywave82/opencubicplayer/commit/93ec77fa19226a42972d599a2037e2b0cbd2ac00.patch?full_index=1"
      sha256 "fef3fde17c923a732aa831825ba84efa9d3b6652b40964dfad5a07ad33b511ce"
    end
  end

  livecheck do
    url :homepage
    regex(/href=.*?ocp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "9c40cfcc02399a27905449ba2b8a4420cbd6b6836eb9496a5ea8208ea91efdb9"
    sha256 arm64_ventura:  "4b507936cb44e1f1eeef0555dce047d4115812c45ef6a80eec7127080017514b"
    sha256 arm64_monterey: "6fc04ea0e775c8ad0eaec3e886aad49876e507453e505cdea34ca85466473c55"
    sha256 sonoma:         "db1c374f4d234dfce8b34e4ca5fcda181e6cfe7b0f79451db12bd7813210d008"
    sha256 ventura:        "86fd71c9434c9254c4b91fae6a246e8e7595390fca2627a6ee28d6117a1c4db2"
    sha256 monterey:       "a408931b6cb7341bf1198afa2aff10e2bf4753cd6731af7068433ed072d8a23e"
    sha256 x86_64_linux:   "595c0efa0a0e7574138cceb2170925db092aec5d853e22c69b474d7c25383bc3"
  end

  depends_on "pkg-config" => :build
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

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
  end

  resource "unifont" do
    url "https://ftp.gnu.org/gnu/unifont/unifont-15.0.06/unifont-15.0.06.tar.gz"
    sha256 "36668eb1326d22e1466b94b3929beeafd10b9838bf3d41f4e5e3b52406ae69f1"
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
