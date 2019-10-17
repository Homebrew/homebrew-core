class Onscripter < Formula
  desc "NScripter-compatible visual novel engine"
  homepage "https://onscripter.osdn.jp/"
  url "https://onscripter.osdn.jp/onscripter-20190527.tar.gz"
  sha256 "4e72830051dbe79fad21128888652dd31383ef999e9adba2fea97559a5158452"

  bottle do
    cellar :any
    sha256 "16f2fabf06b8a3b4374718f80d3f65af653c0b9cbcfc1cb22fff177223543a8c" => :catalina
    sha256 "d63912622aadbcb3d410aa2a0a6c536c9cc04dcecdf71ec735a0327344f91e3f" => :mojave
    sha256 "2f710dd52fe2ad18f1ab3d989f2aadcb23854814e7108c211438152b55707a20" => :high_sierra
    sha256 "e8d758ff8058001359060308c6ccba4ae09bafee7af9299844686c6912714076" => :sierra
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
