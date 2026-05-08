class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/refs/tags/dosbox-x-v2026.05.02.tar.gz"
  sha256 "5ab3584870bec378b495242f20f03ecbef2cd032a128ee3394a88ff7a53cd914"
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
    sha256                               arm64_tahoe:   "aa7c0be78cb0c7b7c56b04685d7cbae859da3e62a5d2c7e9981b99ee6a407615"
    sha256                               arm64_sequoia: "3515f02bbd5bf8bf5bc4d593d23c811b0e3e1d948259c1cb037cbce74e4bc229"
    sha256                               arm64_sonoma:  "a23326b7f93c1c4f7c5ccf0e10118cc5a0dcd6dbd4dedec0c76cf3bfe996843b"
    sha256                               sonoma:        "fb2c2fe72cab690158fdc35e8e9a9b1a654cd5ce1e539c1de49d801be64055f9"
    sha256                               arm64_linux:   "c20a6d7605e58ca2b45e20cb12cf9ec7b1faf8ec7c1ca6b3262564acf8e516fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "356c3b1cb67a2cec8114579d897531bfd71fa1ced22a62391e6643850e5d7c80"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  depends_on xcode: :build # For metal
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on "sdl2"

  uses_from_macos "ncurses"

  on_macos do
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
    ENV.cxx11

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
