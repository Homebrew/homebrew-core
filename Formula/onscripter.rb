class Onscripter < Formula
  desc "NScripter-compatible visual novel engine"
  homepage "https://onscripter.osdn.jp/onscripter.html"
  url "https://onscripter.osdn.jp/onscripter-20220123.tar.gz"
  sha256 "5da41dc3471eeec8c93153906b39dac0a32edbb2bcefce0fa0a976c148b448ca"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?onscripter[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "4e6df0e04fedd47b9da0b916fada9a996076515e67071ea5e9297cd2c1051618"
    sha256 cellar: :any, arm64_big_sur:  "3d26597e48359f0381f36970443d1496c2d474ed878c3bc5dd9c1ac4b79e562b"
    sha256 cellar: :any, monterey:       "0856c4483613081501e121b6c0838a4aed3b7d259dad67a19f36386f970ca247"
    sha256 cellar: :any, big_sur:        "a6695d3775716fe84a9fbb5e352aca3cef17bec8a990667b45cc84062e33fe25"
    sha256 cellar: :any, catalina:       "a8c7432b1b37ad99a3f3cb231098de002bf86b413b4ffebad837ee0f354d7b3b"
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
