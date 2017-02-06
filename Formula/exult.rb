class Exult < Formula
  desc "Recreation of Ultima 7"
  homepage "http://exult.sourceforge.net/"
  url "svn://svn.code.sf.net/p/exult/code/exult/trunk", :revision => 7520
  version "1.4.9rc1+r7520"
  head "svn://svn.code.sf.net/p/exult/code/exult/trunk"

  bottle do
    sha256 "f9cac006633608c628a8d069e44c7c6f3c1ceb6c9f45eccfb3a011f4ca32fb41" => :el_capitan
    sha256 "c36761dc9db169de70f9e9a56b64c3f609924728562d50f8ed04ac9354c06c9a" => :yosemite
    sha256 "031de2aab1ec65682d2d89f029e4a8f574539d6048c9082a3ce8e5c88084b4fa" => :mavericks
  end

  option "with-audio-pack", "Install audio pack"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "libogg"
  depends_on "libvorbis"

  resource "audio" do
    url "https://downloads.sourceforge.net/project/exult/exult-data/exult_audio.zip"
    sha256 "72e10efa8664a645470ceb99f6b749ce99c3d5fd1c8387c63640499cfcdbbc68"
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
    (pkgshare/"data").install resource("audio") if build.with? "audio-pack"
    prefix.install "Exult.app"
    bin.write_exec_script "#{prefix}/Exult.app/Contents/MacOS/exult"
  end

  def caveats; <<-EOS.undent
    Note that this includes only the game engine; you will need to supply your own
    own legal copy of the Ultima 7 game files. Try here (Amazon.com):
      http://bit.ly/8JzovU

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
