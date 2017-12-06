class Onscripter < Formula
  desc "NScripter-compatible visual novel engine"
  homepage "https://onscripter.osdn.jp/"
  url "https://onscripter.osdn.jp/onscripter-20170814.tar.gz"
  sha256 "07010e633e490f24f4c5a57dd8c7979f519d0a10a2bfbba8e04828753f1ba97a"
  revision 1

  bottle do
    cellar :any
    sha256 "c7843b57d4404e6a7ac61d521bc60e9b572dff73d916c6a95c3ba2a5f5527125" => :high_sierra
    sha256 "d32055f6e69f36da381320ffffb898b4a94e5d29e7a7ae1a00c60a4766439e8c" => :sierra
    sha256 "dab8de0970901e7c63b32ad3d2071895c4259c5eb20a7abf8701b328d55bb8cf" => :el_capitan
  end

  option "with-english", "Build with single-byte character mode"

  depends_on "pkg-config" => :build
  depends_on "sdl"
  depends_on "sdl_ttf"
  depends_on "sdl_image"
  depends_on "sdl_mixer"
  depends_on "smpeg"
  depends_on "jpeg"
  depends_on "lua" => :recommended

  # jpeg 9 compatibility
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/eeb2de3/onscripter/jpeg9.patch"
    sha256 "08695ddcbc6b874b903694ac783f7c21c61b5ba385572463d17fbf6ed75f60a1"
  end

  def install
    incs = [
      `pkg-config --cflags sdl SDL_ttf SDL_image SDL_mixer`.chomp,
      `smpeg-config --cflags`.chomp,
      "-I#{Formula["jpeg"].include}",
    ]

    libs = [
      `pkg-config --libs sdl SDL_ttf SDL_image SDL_mixer`.chomp,
      `smpeg-config --libs`.chomp,
      "-ljpeg",
      "-lbz2",
    ]

    defs = %w[
      -DMACOSX
      -DUSE_CDROM
      -DUTF8_CAPTION
      -DUTF8_FILESYSTEM
    ]

    ext_objs = []

    if build.with? "lua"
      lua = Formula["lua"]
      incs << "-I#{lua.include}"
      libs << "-L#{lua.lib} -llua"
      defs << "-DUSE_LUA"
      ext_objs << "LUAHandler.o"
    end

    if build.with? "english"
      defs += %w[
        -DENABLE_1BYTE_CHAR
        -DFORCE_1BYTE_CHAR
      ]
    end

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
