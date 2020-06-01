class Exult < Formula
  desc "Recreation of Ultima 7"
  homepage "https://exult.sourceforge.io/"
  url "https://github.com/exult/exult/archive/v1.6.tar.gz"
  sha256 "6176d9feba28bdf08fbf60f9ebb28a530a589121f3664f86711ff8365c86c17a"
  head "https://github.com/exult/exult.git"

  bottle do
    rebuild 1
    sha256 "4a0df0a28c993f5e52c51de40e0b4194e73ea1869ca1277dda10e8793258c3c6" => :catalina
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

  def caveats
    <<~EOS
      This formula only includes the game engine; you will need to supply your own
      own legal copy of the Ultima 7 game files for the software to fully function.

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
