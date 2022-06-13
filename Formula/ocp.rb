class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-0.2.99.tar.xz"
  sha256 "d00165e206403b876b18edfc264abc8b6ce3d772be7e784fe4d358e37e57affd"
  license "GPL-2.0-or-later"
  head "https://github.com/mywave82/opencubicplayer.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ocp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "e1209043338a9544dd8a43d76e3139ce198c3c9a93d6e3cee44c6eda9222b9b3"
    sha256 arm64_big_sur:  "d22dfd337c1ab4e38d2b244b591279320788b87707c246eaae47be9e11d41dc1"
    sha256 monterey:       "cbfb8a0015f436b41f8b04dd5a6e01b17cc83e3e74458b8ef53ce57d9af77335"
    sha256 big_sur:        "33f2f6bcf54ed3fc3234a3b33201087110da4fbfefe07f6bb8d798fba05cbe6d"
    sha256 catalina:       "f9e81a76f7187d66421bf8b5d38eca4a7362ed16b214e84680f0e139c62de167"
    sha256 x86_64_linux:   "d91ac3a8e16cb05160b7fc429d5e70fb6f9e4a7a2a7fcb36c1688eb018f740c6"
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

  if MacOS.version < :catalina
    depends_on "sdl"
  else
    depends_on "sdl2"
  end

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
