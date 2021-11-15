class Onscripter < Formula
  desc "NScripter-compatible visual novel engine"
  homepage "https://onscripter.osdn.jp/onscripter.html"
  url "https://onscripter.osdn.jp/onscripter-20200722.tar.gz"
  sha256 "12e5f4ac336ae3da46bf166ff1d439840be6336b19401a76c7d788994a9cd35e"
  license "GPL-2.0"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?onscripter[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "f161b80ef31f27da43da4d8ab6b0b36ed59fe201de38b483fd350756a8a66718"
    sha256 cellar: :any, arm64_big_sur:  "6bf87dccb1539e34ca53a5d2912937d812d91d5540885a53d7e10e9c334a0f1a"
    sha256 cellar: :any, monterey:       "18cf25110f0769f5aa7bbe06d5028f15a3b68d541ff203a6fb62dfe17deb0ccc"
    sha256 cellar: :any, big_sur:        "444a199a064d388e2fdcdc2e0bde6b33b55c61423484269af44e203db2badd49"
    sha256 cellar: :any, catalina:       "6d28e84b6fce1f2b9bbba114b325835cd03250706d510719a5291d370d6d148f"
    sha256 cellar: :any, mojave:         "72be2f1701d8a25edd139c7beeccf563b73e4f802b1c74708e6102f6f6fd8557"
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
