class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.38.tar.xz"
  sha256 "2bc1aa38aacd23131895cd9aa3abd9d1ca5700857034d9f35209e13e061e27a2"

  bottle do
    cellar :any
    sha256 "d21aef0ebf95c77cdcaa82cc26b9752a3d7882a6c248139654fae3be5261baa5" => :catalina
    sha256 "379fa2e570a4987b05068b6ecb4454c9819da9e9c9670f65a0e158e43ea75afc" => :mojave
    sha256 "e05d6ca991df52846ca07fb2d536cf4644bc225f6a729ae3f180fbb5967356a5" => :high_sierra
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
      system "meson", *std_meson_args, "-Dcolors=false", "-Dnls=disabled", ".."
      system "ninja", "install"
    end
  end

  test do
    system bin/"ncmpc", "--help"
  end
end
