class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/refs/tags/dosbox-x-v2026.08.31.tar.gz"
  sha256 "992ea538ea858f9fb196b39de2276ce3048c731965e144e6288202abed109782"
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
    sha256 arm64_golden_gate: "4516f94268f438175e28db9efbe0a8c8227d95fd94fc6acadc516f33ddd379e4"
    sha256 arm64_tahoe:       "ac291913fcbbedb30739eac8f63c7f4231e089718986fb782610d30f78e0963e"
    sha256 arm64_sequoia:     "4d8558778681d2261f901d6ec705ed93ac9afed7196ddf179bb6656e363ebfc4"
    sha256 arm64_sonoma:      "aded9fe9a2c4c843d769118ceef3ab4b25ce14b2bb2b1abc6c28e888a2056c5c"
    sha256 arm64_linux:       "ddd78322191cad52b47cdfa728de559a62f61d9e19086e4469cdb98de28a4c2f"
    sha256 x86_64_linux:      "a70023e71a690b3ce491cc334efb47ad8aa428ef6f750163078838acc5aab468"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on "sdl2-compat"
  depends_on "sdl2_net"

  uses_from_macos "ncurses"

  on_macos do
    depends_on xcode: :build # For metal
    depends_on "gettext"
    depends_on "glib"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "libxrandr"
    depends_on "zlib-ng-compat"
  end

  def install
    # Set `LDFLAGS` to link against the Metal and QuartzCore frameworks on macOS Ventura and later
    # during ./configure to detect the Metal framework
    ENV.append "LDFLAGS", "-framework Metal -framework QuartzCore" if OS.mac? && MacOS.version >= :ventura

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
