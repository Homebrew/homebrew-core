class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/refs/tags/dosbox-x-v2024.10.01.tar.gz"
  sha256 "9940662759b9910e3c4549216be8db0278ceaaa80ace5b19f87b04d0b6ff8a3a"
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
    sha256 arm64_sequoia: "63a69fa78f5e233fcffab6603d0adfe11fc4bfdc627d7522fb994865cd479320"
    sha256 arm64_sonoma:  "ee12e910570c143fe748c6a7f7406be1a917c6d566a580dc06656e0bb49bd727"
    sha256 arm64_ventura: "94bacc0eda5263ffdb07c51111b0cae5146c511a879e9714eba2d75454af626b"
    sha256 sonoma:        "bd61a5e1889cddaa086047b6ec899eeb00982c1eaee4bbb287c7dee34c5b9a0f"
    sha256 ventura:       "776db85c289ed70159da126fd4a7c6d9672ce054cbc122c756ac2d83c8651fe0"
    sha256 x86_64_linux:  "69851fb6278d41a426c011ebfcf7f2b0d631cd196f395d3e56b686ad692f6523"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build

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

  fails_with gcc: "5"

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
