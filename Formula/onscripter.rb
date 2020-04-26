class Onscripter < Formula
  desc "NScripter-compatible visual novel engine"
  homepage "https://onscripter.osdn.jp/"
  url "https://onscripter.osdn.jp/onscripter-20200419.tar.gz"
  sha256 "f77e93d7895918689edab2da97c1e221895681a9cbe21be726b90d44a161648f"

  bottle do
    cellar :any
    sha256 "de5abe8c2fe87429026f99b5c861d062b857ec7ac176d91ec6ec177a4e188057" => :catalina
    sha256 "0cb5bc3c55a8594647f3dcf8710cfcd93d9094ff036e416139311956050e7e2b" => :mojave
    sha256 "239a2823f7da43469765f0a17f542f8e57ded2cbd9c3262c81b3786160c86ee6" => :high_sierra
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
