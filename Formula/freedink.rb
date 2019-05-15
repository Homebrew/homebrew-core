class Freedink < Formula
  desc "Portable version of the Dink Smallwood game engine"
  homepage "https://www.gnu.org/software/freedink/"
  url "https://ftp.gnu.org/gnu/freedink/freedink-109.6.tar.gz"
  sha256 "5e0b35ac8f46d7bb87e656efd5f9c7c2ac1a6c519a908fc5b581e52657981002"

  bottle do
    sha256 "bd306ccb62b03ef425a8fc8e57f9a7b3fe848be849898ce52f2323fb3cc0ceb6" => :mojave
    sha256 "41d9d33884a5be4191d5b04b2688a28ed1c5800d481c6fec739f759ca7bc1378" => :high_sierra
    sha256 "785187db7fff66ffd8951938fb08752d01b747a3f782d8e551ad271ecd28796a" => :sierra
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
