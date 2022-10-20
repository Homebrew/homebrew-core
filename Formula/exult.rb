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
    sha256                               arm64_monterey: "28380485157dd2a521e9c72ff3baa1f1e392694f636697478606c89eb7f0e179"
    sha256                               arm64_big_sur:  "1ac2db0c3d8b26091435336777f22f72594b0474bdd4d13092886f4630a87479"
    sha256                               monterey:       "5202bc6cd443aadfb76b48c6734f03b15c0b20d3cc13eeb7ff90e0233997ce73"
    sha256                               big_sur:        "21159eb863130508a83690868d84c499789c12d4e84594a6156846074e97ef0d"
    sha256                               catalina:       "fc44b27ff30145ab9647dd2336513a376fee5e2884c354697a98925b324788c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8576be4d556f2f557252d541fd91efc5ca46e7d526cf014ba1a5a87d0a5a239b"
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
    if OS.mac?
      system "make", "bundle"
      pkgshare.install "Exult.app/Contents/Resources/data"
      prefix.install "Exult.app"
      bin.write_exec_script "#{prefix}/Exult.app/Contents/MacOS/exult"
    else
      system "make", "install"
    end
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
