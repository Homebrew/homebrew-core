class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.39.tar.xz"
  sha256 "64ebe320c2fbe4dfbff4461ceae730001841d06d48c4882d69f320912a0f11a8"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.musicpd.org/download/ncmpc/0/"
    regex(/href=.*?ncmpc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "9154c89589d332b2fb8060907fd0c6c6251ad1f91a59c0e8371ef99860f51005" => :catalina
    sha256 "5106f3ed9cc57ff174e25e47f60e30a83c290c44d4dc01789a4e1f7a9bc71a86" => :mojave
    sha256 "271706591422328a6a8a1a390cb11b3b53829f642519d4f36a780d24a30ceccc" => :high_sierra
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
