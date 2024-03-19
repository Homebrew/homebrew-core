class Onscripter < Formula
  desc "NScripter-compatible visual novel engine"
  homepage "https://onscripter.osdn.jp/onscripter.html"
  url "https://onscripter.osdn.jp/onscripter-20230825.tar.gz"
  sha256 "03299ab9468b080ac0a90211ad4479376add45db3ef5a46be69b4c23c440fb87"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "976eb85cb68b75c8d05a99a8a7229d95dde665b086d7c3487257ae7b73b2bca0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4500c6b81e79fcce6f25ceb5a725f3f61ca4085dffddb1e7bb2571c81cfb8c51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f988f81af74291e517c4e0010f086de294dd705584c186518f17fabb7dcbf027"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "988db2dba660dba1abc5c8f6145480deb8219dcbc62c4eb7ad6f6cb88afe4435"
    sha256 cellar: :any,                 sonoma:         "f43cce01409904c02640dcfb203932816661c94e3e8cc2a976a743bbdd833651"
    sha256 cellar: :any_skip_relocation, ventura:        "ad135d147b63f7746f4ff8f8c6e4fc24ce5ec7c640aab87ef351272a73144827"
    sha256 cellar: :any_skip_relocation, monterey:       "9a89c54f6daf473e431bbf15173b2b16b117809cd422489d4407b24a5bcb16fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab670d0f52888c0a76694a3c05e889d016d233670b1098dfdb256a6bc5aa277c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06626f8dbf7167cd8e5f8e9a9e6986d7d0988f1c89ba6889bec1cc191f4852c5"
  end

  disable! date: "2024-02-07", because: "uses deprecated `sdl_image`, `sdl_mixer`, and `sdl_ttf`"

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "lua"
  depends_on "sdl12-compat"
  depends_on "sdl_image"
  depends_on "sdl_mixer"
  depends_on "sdl_ttf"
  depends_on "smpeg"

  def install
    # Configuration is done through editing of Makefiles.
    # Comment out optional libavifile dependency on Linux as it is old and unmaintained.
    inreplace "Makefile.Linux" do |s|
      s.gsub!("DEFS += -DUSE_AVIFILE", "#DEFS += -DUSE_AVIFILE")
      s.gsub!("INCS += `avifile-config --cflags`", "#INCS += `avifile-config --cflags`")
      s.gsub!("LIBS += `avifile-config --libs`", "#LIBS += `avifile-config --libs`")
      s.gsub!("TARGET += simple_aviplay$(EXESUFFIX)", "#TARGET += simple_aviplay$(EXESUFFIX)")
      s.gsub!("EXT_OBJS += AVIWrapper$(OBJSUFFIX)", "#EXT_OBJS += AVIWrapper$(OBJSUFFIX)")
    end

    incs = [
      `pkg-config --cflags sdl SDL_ttf SDL_image SDL_mixer`.chomp,
      `smpeg-config --cflags`.chomp,
      "-I#{Formula["jpeg-turbo"].include}",
      "-I#{Formula["lua"].opt_include}/lua",
    ]

    libs = [
      `pkg-config --libs sdl SDL_ttf SDL_image SDL_mixer`.chomp,
      `smpeg-config --libs`.chomp,
      "-L#{Formula["jpeg-turbo"].opt_lib} -ljpeg",
      "-lbz2",
      "-L#{Formula["lua"].opt_lib} -llua",
    ]

    defs = %w[
      -DUSE_CDROM
      -DUSE_LUA
      -DUTF8_CAPTION
      -DUTF8_FILESYSTEM
    ]
    defs << "-DMACOSX" if OS.mac?

    ext_objs = ["LUAHandler.o"]

    k = %w[INCS LIBS DEFS EXT_OBJS]
    v = [incs, libs, defs, ext_objs].map { |x| x.join(" ") }
    args = k.zip(v).map { |x| x.join("=") }
    platform = OS.mac? ? "MacOSX" : "Linux"
    system "make", "-f", "Makefile.#{platform}", *args
    bin.install %w[onscripter sardec nsadec sarconv nsaconv]
  end

  test do
    assert shell_output("#{bin}/onscripter -v").start_with? "ONScripter version #{version}"
  end
end
