class Exult < Formula
  desc "Recreation of Ultima 7"
  homepage "https://exult.sourceforge.io/"
  url "https://github.com/exult/exult/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "f55f682a47009fdc5138571f80ac42eb1fe5c07c8d9ccacaa9de66caed039fd3"
  license "GPL-2.0-or-later"
  head "https://github.com/exult/exult.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sequoia: "fc3d163167021d5441dea24083a03c81b201b9d88111bd81d003c6fd10573013"
    sha256                               arm64_sonoma:  "38b60efb5c42fd1e5d4f2399f358a737da0cbbc389f8339d9ab5c482dbf435ee"
    sha256                               arm64_ventura: "49fae5e5ddd4f403e1b14f828c27d9de5c8843a14e80da07fbac726092d6871e"
    sha256                               sonoma:        "f028e367037f153473ebb5c7745a8e67370b462dda94f58b73fcfd4056d02f79"
    sha256                               ventura:       "ab2a9bc56740b16999d06d7e033badff5d590fff177ef39d89192ccb1f48502d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d3980038af7e3685759a3b66816117cc35dc2fe58439ebd0d34698d1f6914fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c54f945e4a0822fb82dac2bb910fe8c878ccdb25c111bf6dbb2b040388938b3"
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
