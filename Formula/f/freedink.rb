class Freedink < Formula
  desc "Portable version of the Dink Smallwood game engine"
  homepage "https://www.gnu.org/software/freedink/"
  url "https://ftp.gnu.org/gnu/freedink/freedink-109.6.tar.gz"
  sha256 "5e0b35ac8f46d7bb87e656efd5f9c7c2ac1a6c519a908fc5b581e52657981002"
  revision 1

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "78a162584ff38dcffdf1485d08a0e29a556f0eada9831fefef6f7dc14755d222"
    sha256 arm64_ventura:  "c3ac13edb0efd994c52954b8a4512c0254f6fbe0874f4bae8416949dc18f2026"
    sha256 arm64_monterey: "3c0d3f2a3362647f774125622db2f836a1f209a5bccfe66a8a7901e357d9434f"
    sha256 arm64_big_sur:  "3d3c10351e92122890d83f912bafe794fa40a673783fa5d99b1bdfcdcd53f0cb"
    sha256 sonoma:         "ae2e232491d307434f8ae51a6f7f373a14da5a08947af29a873988065921b974"
    sha256 ventura:        "cbfd6fd918bcb0af203b66b15c89233bccf573d32448b1fd22fe4b0165fc4fb8"
    sha256 monterey:       "da402e74ba8344d49ec9a0a2c93ab37aa1d3430cb33baf3d995ee3c55489710b"
    sha256 big_sur:        "fd45feffffd96dc600cda4e725619b326ec6a84e96c5844c156aca90fb2390b1"
    sha256 catalina:       "b971d9badc94cb0075963c341ed11c1872e3157b279def6d91fd088743b5e5e4"
    sha256 mojave:         "d44bcab516f79beec47a1ebdc8ec68b66071a34e17abb8556407a3656946d454"
    sha256 high_sierra:    "d022642338ba2979982088f1b65d6230ab71478fdaadfe4966372aa15b909182"
    sha256 x86_64_linux:   "a29b66f12f589cea7e091849b73fb86530086692fd94a627ab4fe86490a8c121"
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

  # Patch for recent SDL
  patch :p0 do
    url "https://raw.githubusercontent.com/openbsd/ports/fc8b95c6/games/freedink/game/patches/patch-src_input_cpp"
    sha256 "fa06a8a87bd4f3977440cdde0fb6145b6e5b0005b266b19c059d3fd7c2ff836a"
  end

  def install
    # cannot initialize a variable of type 'char *' with an rvalue of type 'const char *'
    inreplace "src/gfx_fonts.cpp", "char *familyname", "const char *familyname"
    inreplace "src/gfx_fonts.cpp", "char *stylename", "const char *stylename"
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
