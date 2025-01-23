class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/refs/tags/dosbox-x-v2025.01.01.tar.gz"
  sha256 "40290a073f6b8894d9c2b8c3d9c39a410f84fe89837c87148653ea03e89cf7b2"
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
    sha256 arm64_sequoia: "f5f1c1b5d8bb992c7f7ce2f4312e11ce5bece8148d5da88217d0c0f0ae4ee79f"
    sha256 arm64_sonoma:  "cbb9aabab4e7e2c759089e43251183e8798d0bac8d6b3f44004cd83054260617"
    sha256 arm64_ventura: "09a6642476abf1d09505f79d5648f99d67a035aa6b1a45146059e655c2f844ea"
    sha256 sonoma:        "eac84f4f5bbff69ca344c2bc85eea193f546130668dddaedf8575ed19a463f3a"
    sha256 ventura:       "1bf58de4c738c933496fb65f1bffcd6fa70b3955f346ebe01f42a9be829095e4"
    sha256 x86_64_linux:  "dcd557e4ad09978c6f129b3746e041716f020e808c58f2d792bc239e59bd6598"
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
