class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/refs/tags/dosbox-x-v2023.09.01.tar.gz"
  sha256 "71bf4477ae1640406fa24023f51766ab158ebf26f0e2f317f6fd7bd84c15b4e6"
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
    sha256 arm64_ventura:  "624373d0a30ed5639434432e333076cc4ae3b3eaaf55f162163dcaa2150ceef0"
    sha256 arm64_monterey: "6752e60c1c2f99b9e93cfd80cef21e85143a666c2659f97792265752cade29ec"
    sha256 arm64_big_sur:  "d2a0bac203d16a92c6b53627231e5b41d838efcd417e9ca0e0c3f447238aafb7"
    sha256 ventura:        "e5fee193ccbd2bcce67464cd7cd9a1125e59be262a914ba2ec79c79e01687060"
    sha256 monterey:       "fe6568b9b67ae1badefe13228b9d63867be1f9754ad7366fd73452aa0b140d1f"
    sha256 big_sur:        "00db7767780674a386babca9522a07b86fc9afbc7eca306f5da23c6dcfc93a8e"
    sha256 x86_64_linux:   "6bde23080e8e1e0e11fcc99506902400b0c01ac1c989cb7130cca0611e35afd7"
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
  uses_from_macos "zlib"

  on_linux do
    depends_on "linux-headers@5.15" => :build
  end

  fails_with gcc: "5"

  def install
    ENV.cxx11

    # See flags in `build-macos-sdl2`.
    args = %w[
      --enable-core-inline
      --enable-sdl2
      --disable-sdl2test
      --disable-sdl
      --disable-sdltest
    ]

    system "./autogen.sh"
    system "./configure", *std_configure_args, *args
    system "make" # Needs to be called separately from `make install`.
    system "make", "install"
  end

  test do
    assert_match "DOSBox-X version #{version}", shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
