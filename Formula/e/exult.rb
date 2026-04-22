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
    rebuild 1
    sha256                               arm64_tahoe:   "a0dbfdb8bd78a5d0aad9492f99ce27f606410f32fb26d5d88b984b1f70d3d2a3"
    sha256                               arm64_sequoia: "0eeb4d2fa5348ffff683b054760640c65aab531ac602fd842fa2ccfe642405d8"
    sha256                               arm64_sonoma:  "52f8b804c1b411144b80b0f75c9b423cb82e929689fcf066b1c250f9078360ef"
    sha256                               sonoma:        "8072faddf279e29551ca3c3c70991a257f6987e03debc6d4d214d4b0bd87ef9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fb86582c8e206293be0d6cca39b27a1d248912b5e50537a3f69c8368e60e209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11fa142c33631b28b7d65fa2adc30b3e795cf98a845ff7a2475acc4d0f3ee1e1"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sdl2"

  on_linux do
    depends_on "alsa-lib"
    depends_on "zlib-ng-compat"
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
