class Onscripter < Formula
  desc "NScripter-compatible visual novel engine"
  homepage "https://onscripter.osdn.jp/onscripter.html"
  url "https://onscripter.osdn.jp/onscripter-20220816.tar.gz"
  sha256 "e2bea400a51777e91a10e6a30e2bb4060e30fe7eb1d293c659b4a9668742d5d5"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?onscripter[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f223d91e0662556c9fe884043eb281dcbdc18243379725854e086388453a08e9"
    sha256 cellar: :any,                 arm64_big_sur:  "63d163adcace56d89e260255434094ab2d2b77e30d93271c1731b85f25cd68f0"
    sha256 cellar: :any,                 monterey:       "7d81e08ba2e63843925e8a0362e306fa4cfad70a4a8a951202b663eb67909f91"
    sha256 cellar: :any,                 big_sur:        "172b79f1e706fe3e1a80ee4a72c823680045f16479f557bc018f4bed43ba3ae4"
    sha256 cellar: :any,                 catalina:       "01c504bbd29eb7c091131b602de7c0c86dfbaa716463cac3dd1c2e09c21be713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5af71d0b02c85f170cb38da7375d85b2fd69e061e2d8bfffb750b8251b1f7dc1"
  end

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
