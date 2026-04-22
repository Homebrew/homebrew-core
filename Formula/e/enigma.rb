class Enigma < Formula
  desc "Puzzle game inspired by Oxyd and Rock'n'Roll"
  homepage "https://www.nongnu.org/enigma/"
  url "https://github.com/Enigma-Game/Enigma/releases/download/1.30/Enigma-1.30-src.tar.gz"
  sha256 "ae64b91fbc2b10970071d0d78ed5b4ede9ee3868de2e6e9569546fc58437f8af"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "10b0cd3364cfc8994f9a702a205e87968c36000fd23bf18c10bf0c8974e905dd"
    sha256 arm64_sequoia: "fc97d79fdc16bd8a249d43dca89623fe82aaa04b37deea691bc9b64d6ecffe71"
    sha256 arm64_sonoma:  "e828d5f71b45bd8d245e19585a681f4f8fc580a5774b577ee02255192b4eddbd"
    sha256 sonoma:        "37bc631fd1d8ec80a8a17a6634f9cfe0f089eb94cdf4128940bfe1f79e2cb830"
    sha256 arm64_linux:   "5b08fcc7d57a457dd3fb211db55f2e187daadafe6699891f818b644281adb44f"
    sha256 x86_64_linux:  "ca6b0609a467268d92dfe296d79b9dc31fd1dc126d4a9e3ed7d2af6c79f8fbc8"
  end

  head do
    url "https://github.com/Enigma-Game/Enigma.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "texi2html" => :build
  end

  depends_on "imagemagick" => :build
  depends_on "pkgconf" => :build

  depends_on "enet"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"
  depends_on "xerces-c"

  uses_from_macos "curl"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--with-system-enet", *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal "Enigma v#{version}", shell_output("#{bin}/enigma --version").chomp
  end
end
