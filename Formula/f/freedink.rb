class Freedink < Formula
  desc "Portable version of the Dink Smallwood game engine"
  homepage "https://www.gnu.org/software/freedink/"
  url "https://ftpmirror.gnu.org/gnu/freedink/freedink-109.6.tar.gz"
  sha256 "5e0b35ac8f46d7bb87e656efd5f9c7c2ac1a6c519a908fc5b581e52657981002"
  license "GPL-3.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:    "9e05f0fa2089dda0023b3f07e54b2e0bd64806e62de6b4a9601ff845cee68d40"
    sha256 arm64_sequoia:  "791eb877668eacf35dbc1e12754a2fc5c40f5804107367fc7f0cc2da76f0974e"
    sha256 arm64_sonoma:   "78a162584ff38dcffdf1485d08a0e29a556f0eada9831fefef6f7dc14755d222"
    sha256 arm64_ventura:  "c3ac13edb0efd994c52954b8a4512c0254f6fbe0874f4bae8416949dc18f2026"
    sha256 arm64_monterey: "3c0d3f2a3362647f774125622db2f836a1f209a5bccfe66a8a7901e357d9434f"
    sha256 arm64_big_sur:  "3d3c10351e92122890d83f912bafe794fa40a673783fa5d99b1bdfcdcd53f0cb"
    sha256 sonoma:         "ae2e232491d307434f8ae51a6f7f373a14da5a08947af29a873988065921b974"
    sha256 ventura:        "cbfd6fd918bcb0af203b66b15c89233bccf573d32448b1fd22fe4b0165fc4fb8"
    sha256 monterey:       "da402e74ba8344d49ec9a0a2c93ab37aa1d3430cb33baf3d995ee3c55489710b"
    sha256 big_sur:        "fd45feffffd96dc600cda4e725619b326ec6a84e96c5844c156aca90fb2390b1"
    sha256 catalina:       "b971d9badc94cb0075963c341ed11c1872e3157b279def6d91fd088743b5e5e4"
    sha256 arm64_linux:    "987d1d124d48dd9ae81001a02a9cd62d37d16758b791d6ea9decb3164dde198d"
    sha256 x86_64_linux:   "a29b66f12f589cea7e091849b73fb86530086692fd94a627ab4fe86490a8c121"
  end

  depends_on "glm" => :build
  depends_on "pkgconf" => :build
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
    url "https://ftpmirror.gnu.org/gnu/freedink/freedink-data-1.08.20190120.tar.gz"
    sha256 "715f44773b05b73a9ec9b62b0e152f3f281be1a1512fbaaa386176da94cffb9d"
  end

  # Patch for recent SDL
  patch :p0 do
    url "https://raw.githubusercontent.com/openbsd/ports/fc8b95c6/games/freedink/game/patches/patch-src_input_cpp"
    sha256 "fa06a8a87bd4f3977440cdde0fb6145b6e5b0005b266b19c059d3fd7c2ff836a"
  end

  # Apply Fedora patch to fix error "Please include config.h first."
  patch :p0 do
    on_linux do
      url "https://src.fedoraproject.org/rpms/freedink/raw/9cd2c23c5a951b4de3ab53cdf72bd002adab1810/f/gnulib.patch"
      sha256 "1812a5caeece9ffb94ffe65f709635792b26e2acf8ed2bfc1e5735ec0594a2f6"
    end
  end

  def install
    # cannot initialize a variable of type 'char *' with an rvalue of type 'const char *'
    inreplace "src/gfx_fonts.cpp", "char *familyname", "const char *familyname"
    inreplace "src/gfx_fonts.cpp", "char *stylename", "const char *stylename"

    # Avoid windres causing build failure on Linux
    ENV["ac_cv_prog_ac_ct_WINDRES"] = "" if OS.linux?

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"

    resource("freedink-data").stage do
      inreplace "Makefile", "xargs -0r", "xargs -0"
      system "make", "install", "PREFIX=#{prefix}"
    end
  end

  test do
    assert_match "GNU FreeDink 109.6", shell_output("#{bin}/freedink -vwis")
    assert_path_exists share/"dink/dink/Dink.dat"
  end
end
