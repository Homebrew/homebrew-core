class Onscripter < Formula
  desc "NScripter-compatible visual novel engine"
  homepage "https://onscripter.osdn.jp/onscripter.html"
  url "https://onscripter.osdn.jp/onscripter-20220123.tar.gz"
  sha256 "5da41dc3471eeec8c93153906b39dac0a32edbb2bcefce0fa0a976c148b448ca"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?onscripter[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a781358b2699b5aa3d992d9270843a8ebe80801d988cabff27f91f061922abf9"
    sha256 cellar: :any,                 arm64_big_sur:  "3609369970e2d5012139a19112ac0ecdba89d59a9ddaa7f80e5c7524184e0d25"
    sha256 cellar: :any,                 monterey:       "d9b796717af24b8eaa0e4d29216a798ccaaf494a835fdb94c3595f320e9d6efa"
    sha256 cellar: :any,                 big_sur:        "4fee891a894c2fdc9c49a041a0dcf67e37d71113ab3b81e6b7db2f66a64c8a03"
    sha256 cellar: :any,                 catalina:       "c8be7c98084d6b74d4ad097c0c96411aa172dcbd89f5284f8d3ad16a38df4984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c30b7f50bd386e488c9ced755daf2d5096176c80aca9e321937e03d50a09013c"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "lua"
  depends_on "sdl"
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
