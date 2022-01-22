class Onscripter < Formula
  desc "NScripter-compatible visual novel engine"
  homepage "https://onscripter.osdn.jp/onscripter.html"
  url "https://onscripter.osdn.jp/onscripter-20220115.tar.gz"
  sha256 "b77bf03eb66cee5d3fc1b22a05507c3e4b97f9e6008964728c96278f6e4b71b9"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?onscripter[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "6d7d5770f444cc82ee6adb2512b1feb9fb03d0725e9b11c8b856dcd8ff8857d0"
    sha256 cellar: :any, arm64_big_sur:  "3ba1921cfefbf0c643551c5c8c0fd5f552dd1b90c96af281d276520e1ad1a9df"
    sha256 cellar: :any, monterey:       "e3ffba8f1de102a41700dc1aa6ebf158bf946a2a6b27d38eea7340100d37333f"
    sha256 cellar: :any, big_sur:        "c4bfb394196a2edb031d5c51f0014a92cc8da12a124d2fa7afdb7f9fcbc92b7b"
    sha256 cellar: :any, catalina:       "77574e6be100b2f0e2dcd48dc8852c58d471851d47c49bd335e2c9497078666e"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "lua"
  depends_on "sdl"
  depends_on "sdl_image"
  depends_on "sdl_mixer"
  depends_on "sdl_ttf"
  depends_on "smpeg"

  def install
    incs = [
      `pkg-config --cflags sdl SDL_ttf SDL_image SDL_mixer`.chomp,
      `smpeg-config --cflags`.chomp,
      "-I#{Formula["jpeg"].include}",
      "-I#{Formula["lua"].opt_include}/lua",
    ]

    libs = [
      `pkg-config --libs sdl SDL_ttf SDL_image SDL_mixer`.chomp,
      `smpeg-config --libs`.chomp,
      "-ljpeg",
      "-lbz2",
      "-L#{Formula["lua"].opt_lib} -llua",
    ]

    defs = %w[
      -DMACOSX
      -DUSE_CDROM
      -DUSE_LUA
      -DUTF8_CAPTION
      -DUTF8_FILESYSTEM
    ]

    ext_objs = ["LUAHandler.o"]

    k = %w[INCS LIBS DEFS EXT_OBJS]
    v = [incs, libs, defs, ext_objs].map { |x| x.join(" ") }
    args = k.zip(v).map { |x| x.join("=") }
    system "make", "-f", "Makefile.MacOSX", *args
    bin.install %w[onscripter sardec nsadec sarconv nsaconv]
  end

  test do
    assert shell_output("#{bin}/onscripter -v").start_with? "ONScripter version #{version}"
  end
end
