class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/refs/tags/dosbox-x-v2025.05.03.tar.gz"
  sha256 "b29a2c9c38bfe1d1c1f2420d546b8c2456ae2ddce4c1f6b4d19f258841ce1581"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git", branch: "master"

  # We check multiple releases because upstream sometimes creates releases with
  # a `dosbox-x-windows-` tag prefix and we've historically only used releases
  # with the `dosbox-x-` tag prefix. If upstream stops creating `...windows-`
  # releases in the future (or they are versions that are also appropriate for
  # the formula), we can update this to us the `GithubLatest` strategy.
  livecheck do
    url :stable
    regex(/^dosbox-x[._-]v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 arm64_sequoia: "6e250e527c94b3a1b9ea2893d64a6ee939178dcacdf42d1e9e158fc6b6fa8893"
    sha256 arm64_sonoma:  "5d3a7fe6f5d0c7bc5df0a8ac74d375fd4496dbf6532a3df186e60cfd1903ffe5"
    sha256 arm64_ventura: "8405eb97c9b5b2460c2f7b03c0548a9be7ff2f3b304b4c0d07719652d83f79ec"
    sha256 sonoma:        "f557edc8c2354c5cb391faa9761566d496c19db26a79e05a5b627fb37ebf2ba0"
    sha256 ventura:       "0c463405ea683834c40157a3dab895df130e8422ef2f2750338e50b55da0789e"
    sha256 arm64_linux:   "2a3e03f8c61d44bb49c56381068e574dcdfb7d69736ae757ece8046642bb2420"
    sha256 x86_64_linux:  "6501a5f6178f9319250785644006eeefeabfec0bbd52e6a6bdfaafc4482bc88b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on macos: :high_sierra # needs futimens
  depends_on "sdl2"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "glib"
  end

  on_linux do
    depends_on "linux-headers@5.15" => :build
    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "libxrandr"
  end

  def install
    ENV.cxx11

    # See flags in `build-macos-sdl2`.
    args = %w[
      --enable-debug=heavy
      --enable-sdl2
      --disable-sdl2test
      --disable-sdl
      --disable-sdltest
    ]

    system "./autogen.sh"
    system "./configure", *args, *std_configure_args
    system "make" # Needs to be called separately from `make install`.
    system "make", "install"
  end

  test do
    assert_match "DOSBox-X version #{version}", shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
