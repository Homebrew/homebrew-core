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
    rebuild 1
    sha256 arm64_tahoe:   "fd4d9c52bb24671adbae77223a43788a55d1fb948de6210e71ee59e225c049c2"
    sha256 arm64_sequoia: "b3831fa8f34f93d0947d5b6f784553a26efc62fdfa7899333688a3bd106b2715"
    sha256 arm64_sonoma:  "3f335d476fb1ae9890c156ed2755643b57caa2f0c7f0be693beebd87a8436268"
    sha256 arm64_ventura: "bf746bc868a57ce1b6a790b5a07decea4cb49d5a9681c198cfcca74ce2abad08"
    sha256 sonoma:        "f5e3d6df263e52c29acf741903088ed5a1f9c24c10de0bbf35352b8c36da1483"
    sha256 ventura:       "e7e366991faff23c2d558f8b6e609ea167c51f0ae9da3f6af96e47983d7cd896"
    sha256 arm64_linux:   "91d2cd8eb95c2dcfea89654e27709650bffc25588754f97cb869e34e94cbdf18"
    sha256 x86_64_linux:  "cc28152648d5a5891bb4817e9c0e26895181b902ebf4c87b92dbaf74f2e74072"
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
