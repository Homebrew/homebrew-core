class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.43.tar.xz"
  sha256 "7abf3c83d3a77c18681a8ce90126c8cb1e1884ebde5be2a735293a4f535ed382"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.musicpd.org/download/ncmpc/0/"
    regex(/href=.*?ncmpc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "dcaf0d0af1cff22c8e2913fd55fef28a0205ca0ef88d38955e7dabaa06e3e241" => :big_sur
    sha256 "812169b73cb47055ee1574ff7278afa59ea92b70cafead63992052e7b193f4c0" => :arm64_big_sur
    sha256 "b94f6244a29cbc00d222d8b938fc44a550c2779490b1323c0d2df65eda0585c6" => :catalina
    sha256 "ada5b8151c3e9801a270cb9c5c20cc5d24770b0d6afb71ab6ac773eccdb221d2" => :mojave
  end

  depends_on "boost" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libmpdclient"
  depends_on "pcre"

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
