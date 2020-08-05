class Ncmpc < Formula
  desc "Curses Music Player Daemon (MPD) client"
  homepage "https://www.musicpd.org/clients/ncmpc/"
  url "https://www.musicpd.org/download/ncmpc/0/ncmpc-0.38.tar.xz"
  sha256 "2bc1aa38aacd23131895cd9aa3abd9d1ca5700857034d9f35209e13e061e27a2"

  bottle do
    cellar :any
    sha256 "ca880e781bb617e6fbbcfb70168ac8939b8b5a04bbc24128d68bb9450b4af498" => :catalina
    sha256 "aacbb298f4ceb0911d117babf04e5ce7e2dc17f8999805bc40cd784c256814be" => :mojave
    sha256 "7891f4939522591774bdeab323a49c53f3f0742f64eed19389ece06762b2beec" => :high_sierra
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
