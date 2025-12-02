class Exult < Formula
  desc "Recreation of Ultima 7"
  homepage "https://exult.sourceforge.io/"
  url "https://github.com/exult/exult/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "1734fb8fc76696c7697f00d53e1c5c04b889ab4cabd95e4a3e0380bc35ee5392"
  license "GPL-2.0-or-later"
  head "https://github.com/exult/exult.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "e894b5a6a3c9ef84ac4a8c0b7d75a5e7bede5406fa07f990314e9c9a0057f0a6"
    sha256                               arm64_sequoia: "1ed78e83f24d86ad6d99ae555cb0c3f5f7082ba6ca58c7b6035866b340d3baf7"
    sha256                               arm64_sonoma:  "3a6f16cd3a42e05e5d15fad08325e060b3fb8af4aaaa587ef4443c1a4fabed76"
    sha256                               arm64_ventura: "5c59fa4711bac90f846e57cc711ee14f1b95e01c4e75c5d735820247039e760f"
    sha256                               sonoma:        "869732b9d74e31c56d52eaf5928a3322fe5090bc59521733db83f832b1252a46"
    sha256                               ventura:       "6f382526221cdbadcd1763951073bb7a05fb4abc2b15029c46ef7e37409e1feb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a3dcbb5479149032bd09975ed3da88d8c8406ffdad4c538f96782c0f483b4e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c0d2ab13c126e340f28dcf5d9ae99d26f27c1fa443281cb945cd6d8a4d408a3"
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
