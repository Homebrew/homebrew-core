class Exult < Formula
  desc "Recreation of Ultima 7"
  homepage "https://exult.sourceforge.io/"
  url "https://github.com/exult/exult/archive/v1.6.tar.gz"
  sha256 "6176d9feba28bdf08fbf60f9ebb28a530a589121f3664f86711ff8365c86c17a"
  license "GPL-2.0"
  head "https://github.com/exult/exult.git"

  bottle do
    sha256 "6b3f2e032a2a04e9e3bb2101d91af3fec63195f5e66c9174b976204465a99125" => :catalina
    sha256 "7a3891dc200ec4d01222b3ab7fbc2d4db4d94a8b91f9144fd7e6ab3a79fd8cc7" => :mojave
    sha256 "de9329e08a29b01601a40218bd82746a122294e5322529ca1e678e0aa63ccebb" => :high_sierra
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
