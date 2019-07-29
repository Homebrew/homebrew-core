class Exult < Formula
  desc "Recreation of Ultima 7"
  homepage "https://exult.sourceforge.io/"
  url "https://github.com/exult/exult.git", :revision => "75aff2e97a4867d7810f8907796f58cb11b87a39"
  version "1.4.9rc1+r7520"
  head "https://github.com/exult/exult.git"

  bottle do
    rebuild 1
    sha256 "43967db7a4ff32b78f7478c920eeaf1c730a11952462d9b5bcc2d5b8ee27b932" => :mojave
    sha256 "642d16cef7ecf374ff50e10b32497f2744468010ee452e3e5819cc698215f8dc" => :high_sierra
    sha256 "01c7906864324d3ffe1ce9a11ba7bb60093c379e07d15aab2822e0bdd4789cc3" => :sierra
    sha256 "dcf630b85968a5f4a44f31de4dcc38727ed2d8dbfe3d2e645c585ea3adadfbba" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sdl2"

  # Upstream's fix for recent clang (Xcode 9)
  # https://github.com/exult/exult/commit/083ea2fa
  # Can be removed in next version
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/c9cb2e28/exult/clang9.patch"
    sha256 "e661b7e2e30820bcb74938a203bd367c66c00bc2a7c8de8525e78d70a87a3bd8"
  end

  def install
    # Use ~/Library/... instead of /Library for the games
    inreplace "files/utils.cc" do |s|
      s.gsub! /(gamehome_dir)\("\."\)/, '\1(home_dir)'
      s.gsub! /(gamehome_dir) =/, '\1 +='
    end

    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "EXULT_DATADIR=#{pkgshare}/data"
    system "make", "bundle"
    pkgshare.install "Exult.app/Contents/Resources/data"
    prefix.install "Exult.app"
    bin.write_exec_script "#{prefix}/Exult.app/Contents/MacOS/exult"
  end

  def caveats; <<~EOS
    Note that this includes only the game engine; you will need to supply your own
    own legal copy of the Ultima 7 game files. Try here (amazon.com):
      https://bit.ly/8JzovU

    Update audio settings accordingly with configuration file:
      ~/Library/Preferences/exult.cfg

      To use CoreAudio, set `driver` to `CoreAudio`.
      To use audio pack, set `use_oggs` to `yes`.
  EOS
  end

  test do
    system "#{bin}/exult", "-v"
  end
end
