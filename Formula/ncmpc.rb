class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.36.tar.xz"
  sha256 "4632873dfc8efe61e501dc9184a5b921b482be2ddbedd3d23d05241d477a3e2c"

  bottle do
    cellar :any
    sha256 "eb296eef08ee1bd8be2b0037f39479123301cb6454fed7f32e63f37e32da9b4f" => :catalina
    sha256 "2e240f225487cfd1b07b0bd196c05d152fb421a5dcd8ee9b6686f2f3dbeb1948" => :mojave
    sha256 "a16f92c342b7189b5c6b934a532a7fae6e48f4cd7486cc14b868a3a58434c191" => :high_sierra
  end

  depends_on "boost" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gcc" if DevelopmentTools.clang_build_version <= 800
  depends_on "gettext"
  depends_on "libmpdclient"
  depends_on "pcre"

  fails_with :clang do
    build 800
    cause "error: no matching constructor for initialization of 'value_type'"
  end

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Dcolors=false", "-Dnls=disabled", ".."
      system "ninja", "install"
    end
  end

  test do
    system bin/"ncmpc", "--help"
  end
end
