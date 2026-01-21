class Exult < Formula
  desc "Recreation of Ultima 7"
  homepage "https://exult.sourceforge.io/"
  url "https://github.com/exult/exult/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "5e5113e31dd8010b8dfd00b6b08f76681dc1e88254d357c92f15c202f7ed7e1f"
  license "GPL-2.0-or-later"
  head "https://github.com/exult/exult.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "1d0f0282784693d3467ba3bec7b5667046086fd106e54286fb1af55d4a1f285a"
    sha256                               arm64_sequoia: "ab85d54e261b3f245d2204efdbddce6c415ae05a6d37eba4b494c4caf281e884"
    sha256                               arm64_sonoma:  "9c932e5ebeaeb4997474dab55cf1bda642cd8d7c3756869c8bd2af348673274c"
    sha256                               sonoma:        "63110375bd14efed54f57be8ee7271b807d8ae6d61155a280c1f359bddf2c2d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e730fc066298e15647430892b009dd6c308a31b1d8f6435f97597bdc302ea2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "296dce75d9fea9f215a17ba12631afb66bd676fc81b0fb8032a6ee9970ade4ab"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "EXULT_DATADIR=#{pkgshare}/data"

    if OS.mac?
      system "make", "bundle"
      pkgshare.install "Exult.app/Contents/Resources/data"
      prefix.install "Exult.app"
      bin.write_exec_script prefix/"Exult.app/Contents/MacOS/exult"
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
    system bin/"exult", "-v"
  end
end
