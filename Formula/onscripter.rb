class Onscripter < Formula
  desc "NScripter-compatible visual novel engine"
  homepage "https://onscripter.osdn.jp/"
  url "https://onscripter.osdn.jp/onscripter-20161102.tar.gz"
  sha256 "e9a39b1c45cc47c363eb15773a9944da7a29eff74261ccb656ff5ce4b5fdd5d8"
  revision 2

  bottle do
    cellar :any
    sha256 "8100274df3d26f93cb028f6b28c7ecc40194cf2e4b2151111cbbc431cea94b44" => :sierra
    sha256 "ce14e2a37a764ac33102ff7ec6a67384ea87f41097eeac792a8795e0d668e2eb" => :el_capitan
    sha256 "769ef3374312b8b0545dfefe6a3ba40614a91d9beb558f6b5e85c83164668107" => :yosemite
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
