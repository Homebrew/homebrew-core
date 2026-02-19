class Freedink < Formula
  desc "Portable version of the Dink Smallwood game engine"
  homepage "https://www.gnu.org/software/freedink/"
  url "https://ftpmirror.gnu.org/gnu/freedink/freedink-109.6.tar.gz"
  sha256 "5e0b35ac8f46d7bb87e656efd5f9c7c2ac1a6c519a908fc5b581e52657981002"
  license "GPL-3.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "68cd1561bc7d6a477d2d3457a0c1867bf19cec00fd84c46f0fe74fd18d961cf1"
    sha256 arm64_sequoia: "445ea09cf443c8f5b9bb1f67fc5de82f0735312169e3b009166e1d4ec0cf971b"
    sha256 arm64_sonoma:  "ded6f2f34c6a7dd4e724b04a5fa6e315507f8154908609d81eb5d00d01f0f708"
    sha256 sonoma:        "364f029de96f0aa207090ed4b64d8e4904138435724e4503545868b29e6cc3eb"
    sha256 arm64_linux:   "435f2a3bc5473084034dd5052eda8f0e363674ea9bc59eae57b566274ca1f924"
    sha256 x86_64_linux:  "1cf508674933d7217495e690ffa65a37280aab02d731b415a1613aecffaea5e6"
  end

  depends_on "glm" => :build
  depends_on "pkgconf" => :build
  depends_on "fontconfig"
  depends_on "sdl2"
  depends_on "sdl2_gfx"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  on_macos do
    depends_on "gettext"
  end

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

    system "./configure", "--disable-silent-rules", "--disable-tests", *std_configure_args
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
