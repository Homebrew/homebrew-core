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
    sha256 cellar: :any,                 arm64_ventura:  "b291a3aa9c8aa3b28bef0cbcaf28caefe0650d0a4203dcda060635a0bbf4d806"
    sha256 cellar: :any,                 arm64_monterey: "511063ae79a45b8dfad195cc4b16e84d00aa6932caff7c1835344be4852d65e5"
    sha256 cellar: :any,                 arm64_big_sur:  "3b50dbbdbeb3a938fed69938e3fb29a199464c975aaf15e456d6a87ce7bf3bfa"
    sha256 cellar: :any,                 ventura:        "a2be73c39aa5465ec40890fe7a1f5be4b011e453e467bab092e5cccf07b25b53"
    sha256 cellar: :any,                 monterey:       "6f82c8d95036968a7b159166594dda8ca7e7880608def8a4bacacf13a262c8e3"
    sha256 cellar: :any,                 big_sur:        "f75b61d74d23475c90889a81ad583c5939bb1216db58a2c27dccd6e6a0b0b285"
    sha256 cellar: :any,                 catalina:       "9225c0a491a3ec8292d605929af81daf7f155768ba1eadb1d4e60acaa940765d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a30882de58f50332809a732af98007ef932ddc259e7c928c5ff9f959a349727"
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
