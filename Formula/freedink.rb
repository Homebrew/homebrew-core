class Freedink < Formula
  desc "Portable version of the Dink Smallwood game engine"
  homepage "https://www.gnu.org/software/freedink/"
  url "https://ftp.gnu.org/gnu/freedink/freedink-109.6.tar.gz"
  sha256 "5e0b35ac8f46d7bb87e656efd5f9c7c2ac1a6c519a908fc5b581e52657981002"
  revision 1

  bottle do
    sha256 "088aec509cd68e17a4a591f6d010fc297d7b3e6d9a60244984ba99da6e6a7051" => :mojave
    sha256 "319225a173f440b80b4956035a146b778cb373c65da3ea2cbd4b616a8e33a58e" => :high_sierra
    sha256 "2e76b5e2ac8037e07b879dc2f24549ba09f8bc12c873bfd896f8e7b3222d04e3" => :sierra
  end

  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "check"
  depends_on "cxxtest"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "libzip"
  depends_on "sdl2"
  depends_on "sdl2_gfx"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  resource "freedink-data" do
    url "https://ftp.gnu.org/gnu/freedink/freedink-data-1.08.20190120.tar.gz"
    sha256 "715f44773b05b73a9ec9b62b0e152f3f281be1a1512fbaaa386176da94cffb9d"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
    resource("freedink-data").stage do
      inreplace "Makefile", "xargs -0r", "xargs -0"
      system "make", "install", "PREFIX=#{prefix}"
    end
  end

  test do
    assert_match "GNU FreeDink 109.6", shell_output("#{bin}/freedink -vwis")
    assert FileTest.exists?("#{share}/dink/dink/Dink.dat")
  end
end
