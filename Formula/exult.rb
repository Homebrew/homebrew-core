class Exult < Formula
  desc "Recreation of Ultima 7"
  homepage "https://exult.sourceforge.io/"
  url "https://github.com/exult/exult/archive/v1.8.tar.gz"
  sha256 "dae6b7b08925d3db1dda3aca612bdc08d934ca04de817a008f305320e667faf9"
  license "GPL-2.0-or-later"
  head "https://github.com/exult/exult.git", branch: "master"

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

  def install
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
