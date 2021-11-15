class Exult < Formula
  desc "Recreation of Ultima 7"
  homepage "https://exult.sourceforge.io/"
  url "https://github.com/exult/exult/archive/v1.6.tar.gz"
  sha256 "6176d9feba28bdf08fbf60f9ebb28a530a589121f3664f86711ff8365c86c17a"
  license "GPL-2.0-or-later"
  head "https://github.com/exult/exult.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "a29c81a3aa2359aefce36af2139b3d1f62dc04c0085ad55571bc71dfb1a79604"
    sha256 arm64_big_sur:  "1dafcc7b0c6a54ced59284c8109a01deb628a8bd7e8b2138e38cc540280fa97c"
    sha256 monterey:       "9400d890cf3856c5aad4b002b77fef8952d89f312f465d6fe7c444c0c83335b7"
    sha256 big_sur:        "af93f694844a8f0abdf22f7f8048ffac29992b6d027841fde98d98509876a00b"
    sha256 catalina:       "1b5343fcca2332c05f7b75412dccdc0bb84fb7dd2cceb47fdb3ed7a8cdb319ae"
    sha256 mojave:         "45efe9a12cb0a446543a03c45f412c96355ef4d7dd4bef4b016b8e9bc98e3df7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sdl2"

  # Xcode 12 compile fix for 1.6.x branch - https://github.com/exult/exult/pull/61
  patch do
    url "https://github.com/exult/exult/commit/b98a9eb195bf8b3f55df56499d2a7c2c5d8809d0.patch?full_index=1"
    sha256 "c1c5b1e9e4994ecdfaba6285b86222123ee6b5590bcd8e7400871a4e65836fe0"
  end

  def install
    # Use ~/Library/... instead of /Library for the games
    inreplace "files/utils.cc" do |s|
      s.gsub!(/(gamehome_dir)\("\."\)/, '\1(home_dir)')
      s.gsub!(/(gamehome_dir) =/, '\1 +=')
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
