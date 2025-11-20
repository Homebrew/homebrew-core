class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/refs/tags/dosbox-x-v2025.10.07.tar.gz"
  sha256 "fed630dba74f1ad1552bc5ec94cb68f70737e67a7ca1768f6071b255426ce117"
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
    sha256                               arm64_tahoe:   "10b4217eeddf7dfbdadfd38c81b940d733407c708f075de792ba7e532dcbde76"
    sha256                               arm64_sequoia: "6ded75e5aed788f6bc932e3e7998663215978f190bdeafd3bd7f86ad638258a9"
    sha256                               arm64_sonoma:  "ec5107377e5e371ec30adeb6ee1e44f18a852b4e2ca4e36b4d2f0620c3d67cb8"
    sha256                               sonoma:        "fec035c869127bb3f3cb3b666d1a1e30611b500a361213b832cc1d1b5295f192"
    sha256                               arm64_linux:   "09b78fd526f6ddc14fde58ef82b96582bceddfc1d03a6cc12336592046ec7b7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a417ce0f945ac143020a27e6ac940f60f0f1c1c4d8fdeaa29f5d3eecdbbdd517"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on "sdl2"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "glib"
  end

  on_linux do
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
    system "./configure", *args, *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make" # Needs to be called separately from `make install`.
    system "make", "install"
  end

  test do
    assert_match "DOSBox-X version #{version}", shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
