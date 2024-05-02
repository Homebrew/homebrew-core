class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/refs/tags/dosbox-x-v2024.03.01.tar.gz"
  sha256 "2a89d3196ddc15361f6dc7e6ab142bfe95945d93d527cfd6bacca1f7a401a513"
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
    sha256 arm64_sonoma:   "c5fc239fdfaecfe9e9aa5cd0b7011d2011d0f8df956d592011582388abdd22cf"
    sha256 arm64_ventura:  "b0e949524fab090eeb53f501526ee34a9238c4851ea3af1772aaf660cfeed586"
    sha256 arm64_monterey: "85cad3def53f998a9b2d57cfe0e34b7a7d2ad7f9207f8cab09b4682bcd003ac3"
    sha256 sonoma:         "315e1ad4e8dd4161dd8ad9439182b7a67b24444b03a39f8ce66df3ebb981fe48"
    sha256 ventura:        "36e89f27d3edad1b38ebfe9031620eb51166d9717cf5d72983729c303462fbf0"
    sha256 monterey:       "bd1e197f12758fba0dc539d0bad12a0d185061c6abc3d34c40471ca22d2e30f3"
    sha256 x86_64_linux:   "7000472cd311ec130d2844defac3447f85cff1c5e3b1d58328ae11c384c52b20"
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
