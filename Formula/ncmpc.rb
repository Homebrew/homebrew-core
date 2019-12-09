class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.36.tar.xz"
  sha256 "4632873dfc8efe61e501dc9184a5b921b482be2ddbedd3d23d05241d477a3e2c"

  bottle do
    sha256 "288b7c60146d5041ba4a5ce7a82dcea40a45ba37b87caed9baf6b0f98d329107" => :catalina
    sha256 "7b3d786665c467062935bd484d37fa1781364040a48d83c1da17759615a26bc7" => :mojave
    sha256 "5489be35a603c832514f87c7b1d1368a366abd133085968eb8f6eeaec8da08d4" => :high_sierra
    sha256 "1e7ecbd504ea76bb826e32221e1c8d90135969c785a7ee90e32db77d09ca151e" => :sierra
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
